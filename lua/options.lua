require "nvchad.options"

-- add yours here!

local o = vim.o

o.clipboard = "unnamedplus"

-- Over SSH there's no local clipboard tool, so yank through the terminal with OSC 52
-- (iTerm2 puts it on the Mac clipboard). Paste comes from Neovim's own register, since
-- OSC 52 reads are slow or blocked; use Cmd+V to paste from the Mac.
if vim.env.SSH_TTY then
    local osc52 = require("vim.ui.clipboard.osc52")
    local function paste()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end
    vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
        paste = { ["+"] = paste, ["*"] = paste },
    }
end

-- On Linux (remote), neovim is launched via SSH without sourcing the shell rc,
-- so nvm/fnm node installations are missing from PATH. Find and add them.
if vim.fn.has("mac") ~= 1 then
    local candidates = {
        vim.fn.glob(vim.fn.expand("~/.nvm/versions/node/*/bin"), false, true),
        vim.fn.glob(vim.fn.expand("~/.local/share/fnm/node-versions/*/installation/bin"), false, true),
        vim.fn.glob(vim.fn.expand("~/.fnm/node-versions/*/installation/bin"), false, true),
    }
    for _, dirs in ipairs(candidates) do
        for _, dir in ipairs(dirs) do
            if vim.fn.filereadable(dir .. "/npm") == 1 then
                vim.env.PATH = dir .. ":" .. vim.env.PATH
                break
            end
        end
    end
end

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- o.cursorlineopt ='both' -- to enable cursorline!

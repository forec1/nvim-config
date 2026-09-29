require "nvchad.autocmds"

-- Auto-reload files changed outside Neovim (git pull/checkout/commit, lazygit, Claude, etc.)
vim.opt.autoread = true

-- Note: don't define a FileChangedShell autocmd. When one exists, Neovim hands the
-- reload decision to it, and with v:fcs_choice left empty the buffer is never reloaded.
local function checktime()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
        vim.cmd("silent! checktime")
    end
end

vim.api.nvim_create_autocmd(
    { "FocusGained", "BufEnter", "WinEnter", "TermClose", "TermLeave", "CursorHold", "CursorHoldI" },
    { callback = checktime }
)

-- The events above don't fire while you stay in a terminal split (e.g. Claude) or when
-- the terminal doesn't report focus changes, so also poll once a second.
vim.uv.new_timer():start(1000, 1000, vim.schedule_wrap(checktime))

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
    end,
})

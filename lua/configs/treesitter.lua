local options = {
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "fish",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

-- nvim-treesitter v1 (new API) removed the `configs` submodule
local ok, mod = pcall(require, "nvim-treesitter.configs")
if not ok then
    mod = require("nvim-treesitter")
end
mod.setup(options)

-- nvim-treesitter's master branch registers this directive for pre-0.12 Neovim, where each
-- capture was a single node. On 0.12 it gets a list of nodes and errors on every fenced code
-- block in markdown, so re-register it to handle both.
local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = match[pred[2]]
    if type(node) == "table" then
        node = node[#node]
    end
    if not node then
        return
    end
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias }) or aliases[alias] or alias
end, { force = true })

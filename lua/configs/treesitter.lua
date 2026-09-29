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

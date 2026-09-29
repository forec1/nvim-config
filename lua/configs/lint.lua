local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
    python = { "flake8" },
}

lint.linters.luacheck.args = {
    "--formatter",
    "plain",
    "--globals",
    "love",
    "vim",
}

lint.linters.flake8.args = {
    "--max-line-length",
    "160",
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})

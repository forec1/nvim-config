require("mason-nvim-dap").setup({
    ensure_installed = { "python", "codelldb", "cpptools" },
    automatic_installation = { exclude = {} },
})

local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local machine = require("machine")

vim.lsp.servers = {
    "pyright",
    "clangd",
    "lua_ls",
}

vim.lsp.config("pyright", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        python = {
            pythonPath = machine.python, -- set per machine in lua/machine.lua / lua/local.lua
            analysis = {
                typeCheckingMode = "off",
            },
        },
    },
})
vim.lsp.enable({ "pyright" })

vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
})
vim.lsp.enable({ "clangd" })

vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim", "love" },
            },
            workspace = {
                -- library = {
                --     -- vim.fn.expand("$VIMRUNTIME/lua"),
                --     -- vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                --     vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                --     vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                --     -- "${3rd}/love2d/library",
                -- },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})
vim.lsp.enable({ "lua_ls" })
-- read :h vim.lsp.config for changing options of lsp servers

return {
    "MunifTanjim/nui.nvim",
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        -- This is where you tell Neovim to use specific Snacks modules
        opts = function()
            return require("configs.snacks").opts
        end,
    },
    {
        "coder/claudecode.nvim",
        priority = 1000,
        lazy = false,
        opts = function()
            -- In-editor Snacks split. Set vim.g.claude_external = true to fall back to iTerm2.
            if not vim.g.claude_external then
                return {
                    terminal_cmd = vim.fn.exepath("claude") ~= "" and vim.fn.exepath("claude")
                        or vim.fn.expand("~/.local/bin/claude"),
                    terminal = {
                        provider = "snacks",
                        split_side = "right",
                        split_width_percentage = 0.40,
                    },
                }
            end
            return {
                terminal = {
                    provider = "external",
                    provider_opts = {
                        external_terminal_cmd = function(cmd, env)
                            local claude_bin = vim.fn.exepath("claude")
                            if claude_bin == "" then
                                claude_bin = vim.fn.expand("~/.local/bin/claude")
                            end
                            local full_cmd = cmd:gsub("^claude", claude_bin)
                            local cwd = vim.fn.getcwd()
                            local env_exports = ""
                            if env then
                                for k, v in pairs(env) do
                                    env_exports = env_exports .. string.format("export %s='%s'; ", k, v)
                                end
                            end
                            local apple_script = string.format([[
                                tell application "iTerm2"
                                    set newWindow to create window with default profile
                                    tell current session of newWindow
                                        write text "cd '%s' && %s%s"
                                    end tell
                                end tell]], cwd, env_exports, full_cmd)
                            return { "osascript", "-e", apple_script }
                        end,
                    },
                },
            }
        end,
        config = function(_, opts)
            require("claudecode").setup(opts)
        end,
        keys = {
            { "<leader>a", nil, desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter-context")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    -- {
    --     "stevearc/conform.nvim",
    --     event = "BufWritePre", -- uncomment for format on save
    --     opts = require("configs.conform"),
    -- },
    --
    -- {
    --     "zapling/mason-conform.nvim",
    --     event = "VeryLazy",
    --     dependencies = { "conform.nvim" },
    --     config = function()
    --         require("configs.mason-conform")
    --     end,
    -- },

    {
        "nvim-tree/nvim-tree.lua",
        opts = require("configs.nvim-tree"), -- hook in the override
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        config = function()
            require("configs.mason-dap")
        end,
    },

    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        config = function()
            require("configs.dap")
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        event = "VeryLazy",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("configs.dap-python")
        end,
    },

    {
        "nvim-neotest/nvim-nio",
    },

    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("configs.dap-ui")
        end,
    },
    -- {
    --     "inhesrom/remote-ssh.nvim",
    --     branch = "master",
    --     dependencies = {
    --         "inhesrom/telescope-remote-buffer", --See https://github.com/inhesrom/telescope-remote-buffer for features
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "neovim/nvim-lspconfig",
    --         -- nvim-notify is recommended, but not necessarily required into order to get notifcations during operations - https://github.com/rcarriga/nvim-notify
    --         "rcarriga/nvim-notify",
    --     },
    --     config = function()
    --         require("telescope-remote-buffer").setup(
    --             -- Default keymaps to open telescope and search open buffers including "remote" open buffers
    --             --fzf = "<leader>fz",
    --             --match = "<leader>gb",
    --             --oldfiles = "<leader>rb"
    --         )
    --
    --         -- setup lsp_config here or import from part of neovim config that sets up LSP
    --         require("nvchad.configs.lspconfig").defaults()
    --         local lsp_config = require("configs.lspconfig")
    --
    --         require("remote-ssh").setup({
    --             on_attach = lsp_config.on_attach,
    --             capabilities = lsp_config.capabilities,
    --             filetype_to_server = lsp_config.filetype_to_server,
    --         })
    --     end,
    -- },

    {
        "petertriho/nvim-scrollbar",
        dependencies = {
            "lewis6991/gitsigns.nvim", -- Required for Git marks
            "kevinhwang91/nvim-hlslens", -- Optional: for Search marks
        },
        event = { "BufReadPost", "BufNewFile" }, -- Lazy load for performance
        config = function()
            local scrollbar = require("scrollbar")

            -- Setup search integration if you use hlslens
            require("scrollbar.handlers.search").setup()

            scrollbar.setup({
                show = true,
                handle = {
                    text = " ",
                    blend = 30, -- 0 is opaque, 100 is transparent
                    color = nil,
                },
                marks = {
                    Search = { color = "#ff9e64" }, -- Orange for search
                    Error = { color = "#db4b4b" }, -- Red for errors
                    Warn = { color = "#e0af68" }, -- Yellow for warnings
                    Info = { color = "#0db9d7" },
                    Hint = { color = "#9920B1" },
                    GitAdd = { color = "#10b981" }, -- Green for Git additions
                    GitChange = { color = "#7aa2f7" },
                    GitDelete = { color = "#db4b4b" },
                },
                handlers = {
                    gitsigns = true, -- Enable Git marks
                    diagnostics = true, -- Enable LSP marks
                    search = true, -- Enable search marks
                },
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            -- cfg options
            floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
            -- will set to true when fully tested, set to false will use whichever side has more space
            -- this setting will be helpful if you do not want the PUM and floating win overlap
            hint_inline = function()
                return "right_align"
            end,
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Markdown render toggle" },
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
}

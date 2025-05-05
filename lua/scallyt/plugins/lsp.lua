return {
    {
        "neovim/nvim-lspconfig",
        init = function()
            require("neoconf").setup({})
        end,
        dependencies = {
            -- Core LSP tooling
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Autocompletion + Snippets
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",

            -- Formatting helpers
            "windwp/nvim-autopairs",
            "b0o/schemastore.nvim",

            -- UI & feedback
            "kevinhwang91/nvim-ufo",
            "VidocqH/lsp-lens.nvim",
            "jubnzv/virtual-types.nvim",
            "folke/neoconf.nvim",
            "j-hui/fidget.nvim",

            -- DAP
            "mfussenegger/nvim-dap",
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-jdtls",

            -- Typescript translator
            {
                "dmmulroy/ts-error-translator.nvim",
                config = true,
                ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
            },

            -- Inlay hints
            {
                "chrisgrieser/nvim-lsp-endhints",
                event = "LspAttach",
                opts = {
                    icons = {
                        type = "󰋙 ",
                        parameter = " ",
                    },
                    label = {
                        padding = 1,
                        marginLeft = 0,
                        bracketedParameters = false,
                    },
                    autoEnableHints = false,
                },
            },
        },

        config = function()
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")

            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
            mason_lspconfig.setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "eslint",
                    "clangd",
                    "emmet_language_server",
                    "gopls",
                },
                automatic_installation = true,
            })

            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- CMP setup
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                performance = {
                    max_view_entries = 8,
                },
            })

            -- LSP attach
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode Hover" })
                vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Definition" })
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode Rename" })
                vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Declaration" })
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })

                -- Autoformat Go
                local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
                if client.server_capabilities.documentFormattingProvider and ft == "go" then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function setup_lsp(server, opts)
                lspconfig[server].setup(vim.tbl_extend("force", {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }, opts or {}))
            end

            setup_lsp("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                    },
                },
            })

            setup_lsp("ts_ls")
            setup_lsp("eslint", { settings = { validate = "onSave" } })
            setup_lsp("clangd", {
                on_attach = function(client, bufnr)
                    client.server_capabilities.signatureHelpProvider = false
                    on_attach(client, bufnr)
                end,
            })

            setup_lsp("emmet_language_server", {
                filetypes = {
                    "css", "php", "templ", "eruby", "html",
                    "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact"
                },
                init_options = {
                    showAbbreviationSuggestions = true,
                    showExpandedAbbreviation = "always",
                },
            })

            setup_lsp("gopls", {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                        },
                        staticcheck = true,
                    },
                },
            })

            setup_lsp("templ")

            require("fidget").setup({})
        end,
    },

    -- Formatters: conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            { "<leader>ci", "<cmd>ConformInfo<cr>", desc = "Formatter Info" },
        },
        opts = {
            formatters_by_ft = {
                css = { "prettierd" },
                html = { "prettierd" },
                htmlangular = { "prettierd" },
                javascript = { "prettierd" },
                json = { "prettierd" },
                jsonc = { "prettierd" },
                lua = { "stylua" },
                scss = { "prettierd" },
                typescript = { "prettierd" },
                vue = { "prettierd" },
                fish = { "fish_indent" },
                sh = { "shfmt", "shellharden" },
                bash = { "shfmt", "shellharden" },
                markdown = { "cbfmt", "prettierd", "markdownlint" },
                go = { "goimports", "gofumpt" },
                templ = { "gofumpt", "templ", "injected" },
            },
            format_on_save = function(bufnr)
                local disabled = require("neoconf").get("plugins.conform.disabled")
                if disabled or vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
            notify_on_error = false,
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "2" },
                },
                shellharden = {
                    prepend_args = { "--transform" },
                },
                cbfmt = {
                    prepend_args = { "--config", (os.getenv("HOME") or os.getenv("USERPROFILE")) .. "/.config/cbfmt/cbfmt.toml" },
                },
            },
        },
        init = function()
            vim.api.nvim_create_user_command("ConformFormatToggle", function(args)
                local level = args.bang and "g" or "b"
                vim[level].disable_autoformat = not vim[level].disable_autoformat
                local msg = string.format(
                    "Auto formatting %s %s",
                    vim[level].disable_autoformat and "disabled" or "enabled",
                    level == "b" and string.format("for buffer %d", vim.api.nvim_get_current_buf()) or "globally"
                )
                vim.notify(msg, vim.log.levels.INFO, { title = "conform.nvim" })
            end, { bang = true })
        end,
    },
}

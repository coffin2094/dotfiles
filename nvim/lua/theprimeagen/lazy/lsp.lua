local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local on_attach = function(_, bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr, remap = false }

            map("n", "gd", vim.lsp.buf.definition, opts)
            map("n", "gD", vim.lsp.buf.declaration, opts)
            map("n", "gi", vim.lsp.buf.implementation, opts)
            map("n", "gr", vim.lsp.buf.references, opts)
            map("n", "K", vim.lsp.buf.hover, opts)
            map("n", "<C-k>", vim.lsp.buf.signature_help, opts)

            map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
            map("n", "<leader>vd", vim.diagnostic.open_float, opts)
            map("n", "[d", vim.diagnostic.goto_next, opts)
            map("n", "]d", vim.diagnostic.goto_prev, opts)
            map("n", "<leader>vca", vim.lsp.buf.code_action, opts)
            map("n", "<leader>vrr", vim.lsp.buf.references, opts)
            map("n", "<leader>vrn", vim.lsp.buf.rename, opts)
            map("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        end

        require("conform").setup({
            formatters_by_ft = {
            }
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                -- "rust_analyzer",
                "ts_ls",
                -- "gopls",
                "clangd",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            virtual_text = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}


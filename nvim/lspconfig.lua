return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'saadparwaiz1/cmp_luasnip' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },
  },

  config = function()
    local lsp = require('lsp-zero').preset({
      name = 'minimal',
      set_lsp_keymaps = true,
      manage_nvim_cmp = true,
      suggest_lsp_servers = false,
    })

    -- add your custom keymaps on attach
    lsp.on_attach(function(_, bufnr)
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
    end)

    -- lua workspace awareness
    lsp.nvim_workspace()

    -- Mason setup (automatic install)
    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'tsserver', 'clangd' },
      handlers = { lsp.default_setup },
    })

    -- finalize
    lsp.setup()
  end,
}


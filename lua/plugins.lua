local autocmd = vim.api.nvim_create_autocmd

-- Built-in language server configuration
local lspconfig = require('lspconfig')
require'fidget'.setup{}

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, opts)

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        prefix = '',
      }
    }
  )
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {
  'hls',
  'ts_ls',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

require 'diagnosticls-configs'.init {
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.path.dirname,
  default_config = true,
  format = false,
}

local eslint = require 'diagnosticls-configs.linters.eslint'
require 'diagnosticls-configs'.setup {
  ['sh'] = {
    linter = require 'diagnosticls-configs.linters.shellcheck',
  },
  ['javascript'] = {
    linter = eslint,
  },
  ['typescript'] = {
    linter = eslint,
  },
  ['vim'] = {
    linter = require 'diagnosticls-configs.linters.vint',
  },
}

lspconfig['rust_analyzer'].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    rustfmt = {
      enableRangeFormatting = true,
      extraArgs = { '+nightly' },
    }
  },
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
      diagnostics = {
        disabled = { 'inactive-code' }
      },
      rustfmt = {
        enableRangeFormatting = true,
        extraArgs = { '+nightly' },
      },
    }
  }
}

autocmd('CursorHold', {
  pattern = '',
  command = 'silent! lua vim.lsp.diagnostic.show_line_diagnostics()',
})

-- Completion
local cmp = require'cmp'
local snippy = require'snippy'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  preselect = cmp.PreselectMode.Item,
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end
  },
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
})

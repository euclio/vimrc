local autocmd = vim.api.nvim_create_autocmd

-- Diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '♦',
      [vim.diagnostic.severity.INFO] = '→',
      [vim.diagnostic.severity.HINT] = '…',
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
  },
  virtual_text = {
    prefix = '',
  },
})

-- Built-in language server configuration
require'fidget'.setup{}

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.enable({
  'basedpyright',
  'hls',
  'lua_ls',
  'ruff',
  'rust_analyzer',
  'ts_ls',
})
vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

require 'diagnosticls-configs'.init {
  capabilities = capabilities,
  on_attach = on_attach,
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
  ['python'] = {},
}

vim.lsp.config('rust_analyzer',  {
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
})

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

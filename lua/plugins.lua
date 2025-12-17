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

local capabilities = require('blink.cmp').get_lsp_capabilities()

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

vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportUnusedCallResult = false,
        },
      },
    },
  },
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
      hover = {
        dropGlue = {
          enable = false,
        },
        memoryLayout = {
          enable = false,
        },
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
local blink = require'blink.cmp'
blink.setup {
  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        components = {
          kind = { highlight = "Special" },
        },
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind" },
          { "source_name" },
        },
      },
    },
  },
  fuzzy = { implementation = 'lua' },
  keymap = {
    preset = 'enter',
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
  },
  signature = { enabled = true },
}

-- Diagnostics display
require('trouble').setup {
  icons = {},
  fold_open = 'v',
  fold_closed = '>',
  auto_close = true,
  padding = false,
  indent_lines = false,
  use_diagnostic_signs = true,
  auto_preview = false,
  signs = {
    error = 'error',
    warning = 'warn',
    hint = 'hint',
    information = 'into',
  },
  modes = {
    diagnostics = { auto_open = true },
  }
}

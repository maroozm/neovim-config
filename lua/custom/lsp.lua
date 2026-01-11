local hostname = vim.fn.hostname()
local is_lxplus = hostname:match('lxplus') ~= nil 
  or hostname:match('cern%.ch') ~= nil 
  or vim.env.NVIM_LXPLUS_MODE ~= nil

local map = function(keys, func, desc, bufnr)
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', event.buf)
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', event.buf)
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', event.buf)
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition', event.buf)
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols', event.buf)
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols', event.buf)
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', event.buf)
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', event.buf)
    map('K', vim.lsp.buf.hover, 'Hover Documentation', event.buf)
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', event.buf)

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local servers = {
  clangd = {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=never',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
      '--limit-results=50',
      '--pch-storage=memory',
    },
    capabilities = capabilities,
  },
  bashls = {
    capabilities = capabilities,
  },
}

if not is_lxplus then
  servers.lua_ls = {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = {
            '${3rd}/luv/library',
            unpack(vim.api.nvim_get_runtime_file('', true)),
          },
        },
        completion = { callSnippet = 'Replace' },
        diagnostics = {
          workspaceDelay = 1000,
        },
      },
    },
  }
end

local has_new_lsp_api = vim.fn.has('nvim-0.11') == 1

if not is_lxplus then
  require('mason').setup()
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, { 'stylua', 'shfmt' })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        
        if has_new_lsp_api then
          vim.lsp.config(server_name, server)
          vim.lsp.enable(server_name)
        else
          require('lspconfig')[server_name].setup(server)
        end
      end,
    },
  }
else
  for server_name, server_config in pairs(servers) do
    if has_new_lsp_api then
      vim.lsp.config(server_name, server_config)
      vim.lsp.enable(server_name)
    else
      require('lspconfig')[server_name].setup(server_config)
    end
  end
end

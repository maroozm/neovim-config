vim.opt.shadafile = 'NONE'

vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

vim.opt.foldmethod = 'manual'
vim.opt.foldexpr = ''

if vim.fn.hostname():match('lxplus') then
  vim.opt.undofile = false
  vim.opt.updatetime = 500
  
  vim.api.nvim_create_autocmd('BufReadPre', {
    callback = function()
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.swapfile = false
    end,
  })
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 20
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

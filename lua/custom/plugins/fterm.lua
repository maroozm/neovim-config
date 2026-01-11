return {
  'numToStr/FTerm.nvim',
  lazy = false,
  config = function()
    require('FTerm').setup {
      dimensions = {
        height = 0.7,
        width = 0.5,
      },
      border = 'single',
    }

    vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>', { desc = '[T]erminal Toggle' })
    vim.keymap.set('t', '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = '[T]erminal Toggle' })
  end,
}

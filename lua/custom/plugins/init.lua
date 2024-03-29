-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').setup {
        -- Enable bold keywords.
        bold_keywords = true,
        -- Enable brighter float border.
        bright_border = true,
        noice = {
          -- Available styles: `classic`, `flat`.
          style = 'flat',
        },
      }
    end,
  },
  {
    'HoNamDuong/hybrid.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'Mofiqul/adwaita.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'rockyzhang24/arctic.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    name = 'arctic',
    branch = 'main',
    lazy = false,
    priority = 1000,
  },
  {
    'Yazeed1s/minimal.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'numToStr/FTerm.nvim',
    lazy = false,
    priority = 1000,
  },
}

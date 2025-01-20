if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

-- local opts = {
--   options = {
--     theme = 'gruvbox',
--     globalstatus = true,
--     component_separators = '|',
--     section_separators = '',
--   },
-- }
--
-- require('lualine').setup(opts)

require('mini.statusline').setup()

if vim.g.did_load_luasnip_plugin then
  return
end
vim.g.did_load_luasnip_plugin = true

local ls = require('luasnip')

ls.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
}

local function smart_jump(length, x, y, tries)
  local x2, y2 = unpack(vim.api.nvim_win_get_cursor(0))
  if tries == nil then
    tries = 0
  elseif tries > 10 then
    return
  end

  if x == nil or y == nil then
    x, y = x2, y2
  end

  if x == x2 and y == y2 then
    ls.jump(length)
    tries = tries + 1
    vim.schedule(function()
      smart_jump(length, x, y, tries)
    end)
  end
end

vim.keymap.set({ 'i', 's' }, '<M-n>', function()
  smart_jump(1)
end)
vim.keymap.set({ 'i', 's' }, '<M-p>', function()
  smart_jump(-1)
end)

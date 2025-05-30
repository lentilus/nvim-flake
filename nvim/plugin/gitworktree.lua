if vim.g.did_load_worktree_plugin then
  return
end

vim.g.did_load_worktree_plugin = true

-- vim.cmd.packadd('git-worktree')
local Hooks = require('git-worktree.hooks')
local config = require('git-worktree.config')
local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
  vim.notify('Moved from ' .. prev_path .. ' to ' .. path)
  update_on_switch(path, prev_path)
end)

Hooks.register(Hooks.type.DELETE, function()
  vim.cmd(config.update_on_change_command)
end)

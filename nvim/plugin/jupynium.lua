if vim.g.did_load_jupynium_plugin then
  return
end
vim.g.did_load_jupynium_plugin = true

if vim.fn.executable('jupynium') ~= 1 then
  return
end

vim.cmd.packadd('jupynium')

require('jupynium').setup {
  -- necessary so jupyinium picks up python from nix direnv
  python_host = 'python',

  -- Open the Jupynium server if it is not already running
  -- which means that it will open the Selenium browser when you open this file.
  -- Related command :JupyniumStartAndAttachToServer
  auto_start_server = {
    enable = true,
    file_pattern = { '*.ju.*' },
  },

  -- Automatically open an Untitled.ipynb file on Notebook
  -- when you open a .ju.py file on nvim.
  -- Related command :JupyniumStartSync
  auto_start_sync = {
    enable = true,
    file_pattern = { '*.ju.*', '*.md' },
  },
}

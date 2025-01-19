---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add com_nvim_lsp capabilities
  local cmp_lsp = require('cmp_nvim_lsp')
  local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
  capabilities = vim.tbl_deep_extend('keep', capabilities, cmp_lsp_capabilities)
  -- Add any additional plugin capabilities here.
  -- Make sure to follow the instructions provided in the plugin's docs.
  return capabilities
end

local function escape_wildcards(path)
  return path:gsub('([%[%]%?%*])', '\\%1')
end

-- https://github.com/neovim/nvim-lspconfig/blob/14b5a806c928390fac9ff4a5630d20eb902afad8/lua/lspconfig/util.lua
function M.root_pattern(...)
  local patterns = M.tbl_flatten { ... }
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          if vim.loop.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

return M

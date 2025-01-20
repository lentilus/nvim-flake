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

  local blink_lsp_capabilities = require('blink.cmp').get_lsp_capabilities()

  capabilities = vim.tbl_deep_extend('keep', capabilities, blink_lsp_capabilities)
  -- Add any additional plugin capabilities here.
  -- Make sure to follow the instructions provided in the plugin's docs.
  return capabilities
end

return M

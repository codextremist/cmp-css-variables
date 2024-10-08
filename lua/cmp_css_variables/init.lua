local source = {}
local utils = require("cmp_css_variables.utils")

function source.new()
	local self = setmetatable({}, { __index = source })
	self.cache = {}
	return self
end

function source.is_available()
  -- Ensure vim.g.cmp_css_variables is initialized as a table if it doesn't exist
  vim.g.cmp_css_variables = vim.g.cmp_css_variables or {}

  local replace_filetypes = vim.g.cmp_css_variables.replace_filetypes or false

  -- Default filetypes
  local default_filetypes = { "scss", "sass", "css", "less", "vue", "javascriptreact", "typescriptreact", "svelte" }

  -- filetypes to track
  local tracked_filetypes;

  if replace_filetypes then
    tracked_filetypes = vim.g.cmp_css_variables.filetypes or {}
  else
    -- Create a copy of the default filetypes, then merge additional filetypes
    tracked_filetypes = default_filetypes
    if vim.g.cmp_css_variables.filetypes then
      vim.list_extend(tracked_filetypes, vim.g.cmp_css_variables.filetypes)
    end
  end
  return vim.g.cmp_css_variables.files and vim.tbl_contains(tracked_filetypes, vim.bo.filetype)
end
-- function source.get_keyword_pattern()
-- 	return [[\%(\$_\w*\|\%(\w\|\.\)*\)]]
-- end

function source.get_debug_name()
	return "css-variables"
end

function source.get_trigger_characters()
	return { "-" }
end

function source.complete(self, _, callback)
	local bufnr = vim.api.nvim_get_current_buf()
	local items = {}

	if not self.cache[bufnr] then
		if vim.g.cmp_css_variables.files then
			items = utils.get_css_variables(vim.g.cmp_css_variables.files)
		end

		if type(items) ~= "table" then
			return callback()
		end
		self.cache[bufnr] = items
	else
		items = self.cache[bufnr]
	end

	callback({ items = items or {}, isIncomplete = false })
end

function source.resolve(_, completion_item, callback)
	callback(completion_item)
end

function source.execute(_, completion_item, callback)
	callback(completion_item)
end

return source

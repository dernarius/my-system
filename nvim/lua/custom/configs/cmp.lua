local options = require "plugins.configs.cmp"
local cmp = require "cmp"

options.mapping = {
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, {
    "i", "s",
  }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, {
    "i", "s",
  }),
}

options.preselect = cmp.PreselectMode.None
options.completion.completeopt = "menu,menuone,preview,noselect"

return options

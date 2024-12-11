local M = {}

M.abc = {
  n = {
    [";"] = { ":", "enter cmdline", opts = { nowait = true } },

    -- For a more complex keymap
    ["<leader>tt"] = {
      function()
         require("base46").toggle_transparency()
      end,
      "toggle transparency",
    },
  },
}

return M

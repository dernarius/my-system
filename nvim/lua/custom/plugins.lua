local plugins = {
  {
    "NvChad/base46",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local install = require 'nvim-treesitter.install'
      install["compilers"] = { "zig" }
      install["prefer_git"] = false

      local configs = require("nvim-treesitter.configs")
      configs.setup({
         ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "python",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
     config = function()
        require "plugins.configs.lspconfig"
        require "custom.configs.lspconfig"
     end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require "custom.configs.conform"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require "custom.configs.cmp"
    end,
  },
  {
    "rhysd/reply.vim",
    lazy = false,
  } 
 }

 return plugins

return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "gemini-cli",
        model = "gemini-3-pro-preview"
      },
    },

    opts = {
      log_level = "DEBUG", -- or "TRACE"
    },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = 'cmd: gpg --batch --quiet --decrypt /home/kyle/personal/secrets/gemini_api_key.gpg',
              },
            })
          end,
        }
      },
      strategies = {
        chat = { adapter = "gemini", model = "gemini-3-pro-preview" },
        inline = { adapter = "gemini", model = "gemini-3-pro-preview" },
        agent = { adapter = "gemini", model = "gemini-3-pro-preview" },
      },
    })
  end
}

return
{
  "sylvanfranklin/omni-preview.nvim",
  dependencies = {
    -- Typst
    {
      'chomosuke/typst-preview.nvim',
      config = function()
        require("typst-preview").setup({

          dependencies_bin = {
            ['tinymist'] = "tinymist",
            ['websocat'] = nil
          },
        })
      end,
      lazy = true
    },

    -- CSV
    { 'hat0uma/csvview.nvim', lazy = true },
  },
  opts = {},
  keys = {
    { "<leader>po", "<cmd>OmniPreview start<CR>", desc = "OmniPreview Start" },
    { "<leader>pc", "<cmd>OmniPreview stop<CR>",  desc = "OmniPreview Stop" },
  }
}

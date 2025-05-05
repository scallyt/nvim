return {
  "olexsmir/gopher.nvim",
  ft = "go",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls.nvim",
    "leoluz/nvim-dap-go", -- ha DAP is kell
  },
  config = function(_, opts)
    require("gopher").setup(opts or {})

    -- Ez biztosítja, hogy a parancs akkor fusson le, amikor a plugin is betöltött
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.defer_fn(function()
          vim.cmd("GoInstallDeps")
        end, 1000)
      end,
    })
  end
}


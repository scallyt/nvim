require("scallyt.set")
require("scallyt.remap")
require("scallyt.lazy_init")
require("mason").setup()
vim.cmd [[colorscheme kanagawa]]

function ColorMyPencil()
    color = color or "kanagawa"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencil()

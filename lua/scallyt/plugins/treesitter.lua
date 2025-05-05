return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = {"c", "javascript", "typescript", "go", "templ", "html", "css", "rust", "lua", "vim",
                                "vimdoc", "query", "markdown", "markdown_inline", "php"},
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            }
        }
    end
}
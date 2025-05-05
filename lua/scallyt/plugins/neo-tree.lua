return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
        { "<leader>ee", "<cmd>Neotree toggle<CR>",  desc = "Toggle Neo-tree" },
        { "<leader>ef", "<cmd>Neotree reveal<CR>",  desc = "Reveal current file in Neo-tree" },
        { "<leader>ec", "<cmd>Neotree close<CR>",   desc = "Close Neo-tree" },
        { "<leader>er", "<cmd>Neotree refresh<CR>", desc = "Refresh Neo-tree" },
        { "-",          "<cmd>Neotree reveal<CR>",  desc = "Reveal file in Neo-tree" },
        { "<S-->",      "<cmd>Neotree toggle<CR>",  desc = "Toggle Neo-tree" },
    },
    opts = {
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,

        renderer = {
            indent_markers = {
                enable = true,
            },
            icons = {
                glyphs = {
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                    },
                },
            },
        },

        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
        },

        window = {
            position = "left",
            width = 35,
            mappings = {
                ["<space>"] = "toggle_node",
                ["<cr>"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["C"] = "close_node",
                ["z"] = "close_all_nodes",
                ["R"] = "refresh",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy",
                ["m"] = "move",
                ["q"] = "close_window",
                ["?"] = "show_help",
            },
        },

        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = true,
            },
            follow_current_file = {
                enabled = true,
            },
            use_libuv_file_watcher = true,
        },

        buffers = {
            follow_current_file = {
                enabled = true,
            },
        },
    }
}

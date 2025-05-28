
-- vim.api.nvim_create_autocmd("UiEnter", { -- Changed from BufReadPre
--   desc = "Open neo-tree on enter",
--   group = vim.api.nvim_create_augroup("always_show_neotree", { clear = true }),
--   once = true,
--   callback = function()
--   if not vim.g.neotree_opened then
--     require('neo-tree')
--     vim.cmd('Neotree show')
--     vim.g.neotree_opened = true
--   end
--   end,
-- })
-- vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter'}, {
--   group = vim.api.nvim_create_augroup("always_show_neotree",{clear = true}),
--   -- pattern = {'*.*'},
--   once = true,
--   callback = function(data)
--     if ((not (vim.g.neotree_opened)) and (not (vim.bo.filetype == "checkhealth"))) then
--       require('neo-tree.command').execute({action='show'})
--       -- vim.api.nvim_exec([[silent setlocal rnu]], false)
--       vim.g.neotree_opened = true
--     end
--   end
-- })

-- vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter'}, {
--   group = vim.api.nvim_create_augroup("always_set_neotree_options",{clear = true}),
--   pattern = {'neo-tree*'},
--   callback = function(data)
--     if vim.bo.filetype == "neo-tree" then
--       vim.wo.statuscolumn = [[%!v:lua.require('statuscol').get_statuscol_string()." "]]
--       vim.wo.relativenumber = false
--       vim.wo.number = true
--       vim.wo.foldenable = false
--       -- vim.api.nvim_exec([[silent setlocal rnu]], false)
--     end
--   end
-- })

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- branch = "v3.x",
    branch = "main",
    enabled = false,
    lazy = false,
    --event = { "VeryLazy", },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
          require('window-picker').setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', "quickfix" },
              },
            },
          })
        end,
      },
    },
    opts = function ()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError",
        {text = " ", texthl = "DiagnosticSignError"})
      vim.fn.sign_define("DiagnosticSignWarn",
        {text = " ", texthl = "DiagnosticSignWarn"})
      vim.fn.sign_define("DiagnosticSignInfo",
        {text = " ", texthl = "DiagnosticSignInfo"})
      vim.fn.sign_define("DiagnosticSignHint",
        {text = "󰌵", texthl = "DiagnosticSignHint"})

      return {
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        -- enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil, -- use a custom function for sorting files and directories in the tree
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        source_selector = {
          winbar = true,
          statusline = false
        },
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 0, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "~",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = true,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = " ", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified  = " ", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted   = "✖",-- this can only be used in the git_status source
              renamed   = "󰁕",-- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored   = " ",
              unstaged  = " ",
              staged    = " ",
              conflict  = "",
            }
          },
          -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
          file_size = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = true,
            required_width = 122, -- min width of window required to show this column
          },
          last_modified = {
            enabled = true,
            required_width = 88, -- min width of window required to show this column
          },
          created = {
            enabled = true,
            required_width = 110, -- min width of window required to show this column
          },
          symlink_target = {
            enabled = true,
          },
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-custom-commands-global`
        commands = {},
        window = {
          position = "left",
          width = 42,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            -- Read `# Preview Mode` for more information
            ["l"] = "focus_preview",
            --["S"] = "open_split",
            --["s"] = "open_vsplit",
            ["S"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {"add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "absolute" -- "none", "relative", "absolute"
              }
            },
            ["A"] = {"add_directory",
              config = {
                show_path = "absolute" -- "none", "relative", "absolute"
              }
            },
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = {"copy",
              config = {
                show_path = "absolute" -- "none", "relative", "absolute"
              }
            },
            ["m"] = {"move",
              config = {
                show_path = "absolute" -- "none", "relative", "absolute"
              }
            },
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          }
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = --"open_default", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              -- ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["og"] = { "order_by_git_status", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
            },
          },

          commands = {} -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --              -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          }
        }
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = false,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      filters = { enable = true },
      disable_netrw = true,
      hijack_cursor = true,
      hijack_directories = {
        enable = true,
        auto_open = false,
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      view = {
        width = 42,
        preserve_window_proportions = true,
      },
      sort = {
        sorter = 'case_sensitive',
      },
      modified = {
        enable = true,
      },
      actions = {
        use_system_clipboard = false,
      },
      renderer = {
        -- root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          git_placement = "after",
          symlink_arrow = "  ",
          -- padding = {
          --   icon = "",
          -- },
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
            modified = true,
            hidden = false,
            diagnostics = false,
            bookmarks = false,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "󰆤",
            modified = "~",
            hidden = "󰜌",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged  = " ",
              staged    = " ",
              unmerged = "",
              renamed   = "󰁕",-- this can only be used in the git_status source
              untracked = "",
              deleted   = "✖",-- this can only be used in the git_status source
              ignored   = " ",
            },
          },
        },
      },
    },
    config = function (_, options)
      local nt_api = require("nvim-tree.api")

      nt_api.events.subscribe(nt_api.events.Event.FileCreated, function(file)
        vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
      end)

      nt_api.events.subscribe(nt_api.events.Event.TreeOpen, function()
        local tree_winid = nt_api.tree.winid()

        if tree_winid ~= nil then
          vim.api.nvim_set_option_value('statuscolumn', [[%!v:lua.require('statuscol').get_statuscol_string()." "]], {win = tree_winid})
          vim.api.nvim_set_option_value('foldenable', false, {win = tree_winid})
          vim.api.nvim_set_option_value('relativenumber', false, {win = tree_winid})
          vim.api.nvim_set_option_value('number', true, {win = tree_winid})
        end
      end)

      local nvimTreeFocusOrToggle = function ()
        local currentBuf = vim.api.nvim_get_current_buf()
        local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
        if currentBufFt == "NvimTree" then
          nt_api.tree.toggle()
        else
          nt_api.tree.focus()
        end
      end

      vim.keymap.set("n", [[\]], nvimTreeFocusOrToggle)

      -- Make :bd and :q behave as usual when tree is visible
      vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
        nested = false,
        callback = function(e)

          -- Nothing to do if tree is not opened
          if not nt_api.tree.is_visible() then
            return
          end

          -- How many focusable windows do we have? (excluding e.g. incline status window)
          local winCount = 0
          for _,winId in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(winId).focusable then
              winCount = winCount + 1
            end
          end

          -- We want to quit and only one window besides tree is left
          if e.event == 'QuitPre' and winCount == 2 then
            vim.api.nvim_cmd({cmd = 'qall'}, {})
          end

          -- :bd was probably issued an only tree window is left
          -- Behave as if tree was closed (see `:h :bd`)
          if e.event == 'BufEnter' and winCount == 1 then
            -- Required to avoid "Vim:E444: Cannot close last window"
            vim.defer_fn(function()
              -- close nvim-tree: will go to the last buffer used before closing
              nt_api.tree.toggle({find_file = true, focus = true})
              -- re-open nivm-tree
              nt_api.tree.toggle({find_file = true, focus = false})
            end, 10)
          end
        end
      })

      vim.api.nvim_create_autocmd({'TabEnter','VimEnter'}, {
        group = vim.api.nvim_create_augroup("always_show_file_tree",{clear = true}),
        once = true,
        callback = function(data)

          -- buffer is a real file on the disk
          local real_file = vim.fn.filereadable(data.file) == 1

          -- buffer is a [No Name]
          local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

          if not real_file and not no_name then
            return
          end

          -- open the tree, find the file but don't focus it
          nt_api.tree.toggle({ focus = false, find_file = true, })
        end
      })

      additonal_config = {
        on_attach = function (bufnr)
          local opts = {
            desc = "nvim-tree: lefty righty",
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
          nt_api.config.mappings.default_on_attach(bufnr)
          -- function for left to assign to keybindings
          local lefty = function ()
            local node_at_cursor = nt_api.tree.get_node_under_cursor()
            -- if it's a node and it's open, close
            if node_at_cursor.nodes and node_at_cursor.open then
              nt_api.node.open.edit()
              -- else left jumps up to parent
            else
              nt_api.node.navigate.parent()
            end
          end
          -- function for right to assign to keybindings
          local righty = function ()
            local node_at_cursor = nt_api.tree.get_node_under_cursor()
            -- if it's a closed node, open it
            if node_at_cursor.nodes and not node_at_cursor.open then
              nt_api.node.open.edit()
            end
          end
          vim.keymap.set("n", "h", lefty , opts )
          vim.keymap.set("n", "<Left>", lefty , opts )
          vim.keymap.set("n", "<Right>", righty , opts )
          vim.keymap.set("n", "l", righty , opts )
        end,
      }

      require('nvim-tree').setup(vim.tbl_deep_extend('keep',options,additonal_config))

      require("resession").add_hook('post_load',function()
        nt_api.tree.toggle({ focus = false, find_file = true, })
      end)
    end,
  },
}


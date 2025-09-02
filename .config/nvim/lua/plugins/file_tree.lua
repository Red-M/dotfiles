
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
    "DrKJeff16/project.nvim", -- This makes the cwd of the tree move to the git repo the file is in.
    enabled = not vim.g.nvimpager,
    lazy = false,
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    enabled = not vim.g.nvimpager,
    version = false,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      filters = { enable = false },
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


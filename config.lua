-- Save everything in the session save state
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
-- Make 0 act like ^
vim.cmd("map 0 ^")

-- Make j and k move to the next line when line wrapping is on
vim.cmd("nnoremap j gj")
vim.cmd("nnoremap k gk")

-- Press ctrl+r to search and replace with confirm the selected text
vim.cmd([[vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>]])
-- Same as above but with no confirm
-- vim.cmd([[vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>]])

-- Save on buffer switch
vim.cmd([[
  augroup AutoWrite
    autocmd! BufLeave * silent! w
  augroup END
]])

-- Save on app focus lost
vim.cmd("au FocusLost * silent! w")

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = ","
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferClose<CR>"
-- lvim.keys.normal_mode["<S-'>"] = ":lua require('harpoon.mark').add_file()"
-- lvim.keys.normal_mode["<S-.>"] = ":lua require('harpoon.ui').nav_next()"
-- lvim.keys.normal_mode["<S-m>"] = ":lua require('harpoon.ui').nav_prev()"

-- Don't yank on some commands
vim.api.nvim_set_keymap("v", "p", '"_dP', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
local _, trouble = pcall(require, "trouble.providers.telescope")
lvim.builtin.telescope.pickers.git_files.previewer = nil
lvim.builtin.telescope.pickers.git_files.theme = nil

-- edit telescope layout https://github.com/LunarVim/LunarVim/issues/3406

lvim.builtin.telescope.pickers.live_grep = {
  layout_config = { height = 0.40, width = 0.70, anchor = "S" },
}

lvim.builtin.telescope.pickers.buffers = {
  layout_config = { height = 0.40, width = 0.70, anchor = "S" },
  layout_strategy = "center",
}

lvim.builtin.telescope.defaults.prompt_prefix = "  "
lvim.builtin.telescope.defaults.selection_caret = "❯ "
lvim.builtin.telescope.defaults.mappings.i["<esc>"] = actions.close

-- end of telescope layout changes

lvim.builtin.telescope.defaults.mappings = {
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
    ["<C-c>"] = actions.delete_buffer,
    ["<C-x>"] = trouble.open_with_trouble
  },
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
    ["<C-c>"] = actions.delete_buffer,
    ["<C-x>"] = trouble.open_with_trouble
  },
}

-- stop thinking that src is the project root in kazaam
lvim.builtin.project.patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" }

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "fzy_native")

  -- any other extensions loading
end

lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["x"] = {
  name = "+Trouble",
  x = { "<cmd>TroubleToggle<cr>", "Trouble Toggle" },
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
lvim.builtin.which_key.mappings["q"] = {
  "<cmd>silent! {NvimTreeClose}<cr> <cmd>silent! {Neotest summary close}<cr> <cmd>qall<CR>", "Quit" }

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.treesitter.ensure_installed = "all"

lvim.builtin.treesitter.ignore_install = { "haskell", "phpdoc" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = "<cr>",
    node_incremental = "<cr>",
    scope_incremental = "grc",
    node_decremental = "<bs>",
  },
}
lvim.builtin.treesitter.textobjects = {
  select = {
    enable = true,
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    },
  },
  enable = false,
  swap = {
    -- swap_next = textobj_swap_keymaps,
  },
}

-- Don't overwrite the text following when hitting return on an suggested selection
local cmp = require "cmp"
lvim.builtin.cmp.mapping["<CR>"] = cmp.mapping.confirm {
  behavior = cmp.ConfirmBehavior.Insert,
}

-- generic LSP settings

-- ---@usage disable automatic installation of servers
lvim.lsp.automatic_servers_installation = false
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "elixirls" })

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { command = "prettier" } }

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}
lvim.plugins = {
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    config = function()
      vim.cmd [[
          function! ToggleTermStrategy(cmd) abort
            call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
          endfunction
          let g:test#elixir#exunit#executable = ',test'
          let g:test#elixir#exunit#executable = 'MIX_ENV=test mix test'
          " let g:test#javascript#jest#executable = 'npm test --'

          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
        ]]
      vim.g["test#strategy"] = "toggleterm"
    end,
  },
  { "tpope/vim-abolish" },
  { "tpope/vim-endwise" },
  {
    "machakann/vim-sandwich",
    config = function()
      vim.cmd([[
      let g:sandwich_no_default_key_mappings = 1
      silent! nmap <unique><silent> zd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
      silent! nmap <unique><silent> zr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
      silent! nmap <unique><silent> zdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
      silent! nmap <unique><silent> zrb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

      let g:operator_sandwich_no_default_key_mappings = 1
      " add
      silent! map <unique> za <Plug>(operator-sandwich-add)
      " delete
      silent! xmap <unique> zd <Plug>(operator-sandwich-delete)
      " replace
      silent! xmap <unique> zr <Plug>(operator-sandwich-replace)
      " vim-sandwich
      let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
      let g:sandwich#recipes += [
            \   {
            \     'buns'    : ['%{', '}'],
            \     'filetype': ['elixir'],
            \     'input'   : ['m'],
            \     'nesting' : 1,
            \   },
            \   {
            \     'buns'    : 'StructInput()',
            \     'filetype': ['elixir'],
            \     'kind'    : ['add', 'replace'],
            \     'action'  : ['add'],
            \     'input'   : ['M'],
            \     'listexpr'    : 1,
            \     'nesting' : 1,
            \   },
            \   {
            \     'buns'    : ['%\w\+{', '}'],
            \     'filetype': ['elixir'],
            \     'input'   : ['M'],
            \     'nesting' : 1,
            \     'regex'   : 1,
            \   },
            \   {
            \     'buns'    : ['{:ok, ', '}'],
            \     'filetype': ['elixir'],
            \     'input'   : ['o'],
            \     'nesting' : 1,
            \   },
                  \   {
            \     'buns'    : ['{:error, ', '}'],
            \     'filetype': ['elixir'],
            \     'input'   : ['e'],
            \     'nesting' : 1,
            \   },
            \ ]

      function! StructInput() abort
        let s:StructLast = input('Struct: ')
        if s:StructLast !=# ''
          let struct = printf('%%%s{', s:StructLast)
        else
          throw 'OperatorSandwichCancel'
        endif
        return [struct, '}']
      endfunction


]])
    end
  },
  {
    "wellle/targets.vim",
    config = function()
      vim.cmd([[
      autocmd User targets#mappings#user call targets#mappings#extend({
        \ 'a': {'argument': [{'o': '[([{]', 'c': '[])}]', 's': ','}]},
        \ })
    ]])
    end
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "ray-x/lsp_signature.nvim" },
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'info',
        auto_session_enabled = true,
        auto_session_create_enabled = true,
        auto_session_use_git_branch = true,
        pre_save_cmds = { "tabdo NvimTreeClose" }
      }
    end
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    build = "make",
    event = "BufRead",
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({})
    end
  },
  { "tpope/vim-projectionist" },
  { "tommcdo/vim-ninja-feet" },
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end
  },
  {
    "ruifm/gitlinker.nvim",
    event = "BufRead",
    config = function()
      require("gitlinker").setup {
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require("gitlinker.actions").open_in_browser,
          print_url = false,
          mappings = "<leader>gy",
        },
        callbacks = {
          ["gitlab-ssh.podium.com"] = function(url_data)
            url_data.host = "gitlab.podium.com"
            return
                require "gitlinker.hosts".get_gitlab_type_url(url_data)
          end
        },

      }
    end,
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        nextls = {
          enable = false,
          init_options = {
            experimental = {
              completions = {
                enable = true
              }
            }
          },
          on_attach = function(client, bufnr)
            require("lvim.lsp").common_on_attach(client, bufnr)
          end,
        },
        credo = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = true,
            fetchDeps = true,
            enableTestLenses = false,
            suggestSpecs = false,
          },
          on_attach = function(client, bufnr)
            require("lvim.lsp").common_on_attach(client, bufnr)
          end,
        }
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "jfpedroza/neotest-elixir",
      "antoinemadec/FixCursorHold.nvim"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-elixir"),
        }
      })
    end
  },
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      -- Load custom treesitter grammar for org filetype
      require('orgmode').setup_ts_grammar()

      -- Treesitter configuration
      require('nvim-treesitter.configs').setup {
        -- If TS highlights are not enabled at all, or disabled via `disable` prop,
        -- highlighting will fallback to default Vim syntax highlighting
        highlight = {
          enable = true,
          -- Required for spellcheck, some LaTex highlights and
          -- code block highlights that do not have ts grammar
          additional_vim_regex_highlighting = { 'org' },
        },
        ensure_installed = { 'org' }, -- Or run :TSUpdate org
      }

      require('orgmode').setup({
        org_agenda_files = { '~/orgmode/*' },
        org_default_notes_file = '~/orgmode/refile.org',
      })
    end
  },
  -- colorschemes --
  { "rktjmp/lush.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "mhartington/oceanic-next" },
  { "ChristianChiarulli/nvcode-color-schemes.vim" },
  { "briones-gabriel/darcula-solid.nvim" },
  { "shaunsingh/nord.nvim" },
  { "romainl/Apprentice" },
  { "shaunsingh/solarized.nvim" },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   event = { "InsertEnter", "LspAttach" },
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup({
  --         suggestion = { enabled = false },
  --         panel = { enabled = false },
  --       })
  --       require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration

  --       lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
  --       table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
  --     end, 100)
  --   end,
  -- }
}

lvim.builtin.which_key.mappings["t"] = {
  name = "+Test",
  r = { '<cmd>lua require("neotest").run.run()<CR>', "Nearest" },
  f = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', "Nearest" },
  c = { '<cmd>lua require("neotest").run.stop()<CR>', "Stop" },
  s = { '<cmd>lua require("neotest").summary.toggle()<CR>', "Summary Toggle" },
  k = { '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>', "Jump to previous failed test" },
  j = { '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>', "Jump to next failed test" },
  o = { '<cmd>Neotest output<CR>', "Show test output" },
  O = { '<cmd>Neotest output-panel<CR>', "Toggle output panel" },
  w = { '<cmd>lua require("neotest").watch.toggle()<CR>', "Watch Nearest" },
  W = { '<cmd>lua require("neotest").watch.toggle(vim.fn.expand("%"))<CR>', "Watch File" },

  t = {
    name = "Terminal Tests",
    r = { "<cmd>TestNearest<cr>", "Nearest" },
    f = { "<cmd>TestFile<cr>", "File" },
    s = { "<cmd>TestSuite<cr>", "Suite" },
    l = { "<cmd>TestLast<cr>", "Last" },
    g = { "<cmd>TestVisit<cr>", "Visit" },
  }
}

lvim.builtin.which_key.mappings["X"] = {
  name = "Files",
  X = { '<cmd>let @+=expand("%")<cr>', "Copy relative path" },
  p = { '<cmd>let @+=expand("%:p")<cr>', "Copy absolute path" },
  f = { '<cmd>let @+=expand("%:t")<cr>', "Copy filename" },
  d = { '<cmd>let @+=expand("%:p:h")<cr>', "Copy directory" },
}

lvim.builtin.which_key.mappings["C"] = {
  name = "Code actions",
  tp = { ":ElixirToPipe<cr>", "Elixir to pipe" },
  fp = { ":ElixirFromPipe<cr>", "Elixir from pipe" },
  em = { ":ElixirExpandMacro<cr>", "Expand macro" },
}

function GrepInputStringImmediately()
  local default = vim.api.nvim_eval([[expand("<cword>")]])
  require("telescope.builtin").grep_string({ search = default })
end

lvim.builtin.which_key.mappings["F"] = { "<cmd>lua GrepInputStringImmediately()<CR>", "Grep Text under cursor" }
lvim.builtin.which_key.mappings["B"] = { "<Cmd>Telescope buffers previewer=true<CR>", "Find Buffer" }

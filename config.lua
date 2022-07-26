--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

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
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = ","
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferClose<CR>"

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
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
    ["<C-x>"] = trouble.open_with_trouble
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<c-x>"] = trouble.open_with_trouble,
  },
}

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
lvim.builtin.which_key.mappings["q"] = { "<cmd>qall<CR>", "Quit" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
-- if you don't want all the parsers change this to a table of the ones you want
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
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  --   { command = "black", filetypes = { "python" } },
  --   { command = "isort", filetypes = { "python" } },
  {
    --     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    --     ---@usage arguments to pass to the formatter
    --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    --     extra_args = { "--print-with", "100" },
    --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    -- filetypes = { "typescript", "typescriptreact" },
  },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "eslint" },
  { command = "credo" }
  --   { command = "flake8", filetypes = { "python" } },
  --   {
  --     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "shellcheck",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--severity", "warning" },
  --   },
  --   {
  --     command = "codespell",
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "javascript", "python" },
  --   },
}

-- Additional Plugins
-- lvim.plugins = {
--     {"folke/tokyonight.nvim"},
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }

lvim.plugins = {
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    keys = { "<localleader>tt", "<localleader>tn", "<localleader>ts" },
    config = function()
      vim.cmd [[
          function! ToggleTermStrategy(cmd) abort
            call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
          endfunction
          let g:test#elixir#exunit#executable = ',test'
          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
        ]]
      vim.g["test#strategy"] = "toggleterm"
    end,
  },
  { "tpope/vim-abolish" },
  { "tpope/vim-endwise" },
  { "machakann/vim-sandwich", config = function()
    vim.cmd([[
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


]]   )
  end
  },
  { "wellle/targets.vim", config = function()
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
        -- auto_session_suppress_dirs = { '~/' },
        auto_session_enabled = true,
        auto_session_create_enabled = true,
        auto_session_use_git_branch = true
      }
    end
  },
  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  { "tpope/vim-projectionist"
    --   config = function()
    --   vim.cmd([[
    --     let g:projectionist_heuristics = {
    --       \ "lib/*.java": {"alternate": "src/test/java/{}.java"},
    --       \ "src/test/java/*.java": {"alternate": "src/main/java/{}.java"}
    --     \}
    --   ]])
    -- end
  },
  { "c-brenn/fuzzy-projectionist.vim" },
  { "andyl/vim-projectionist-elixir" },
  { "tommcdo/vim-ninja-feet" },

  -- colorschemes --
  { "rktjmp/lush.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "mhartington/oceanic-next" },
  { "ChristianChiarulli/nvcode-color-schemes.vim" },
  { "briones-gabriel/darcula-solid.nvim" },
  { "shaunsingh/nord.nvim" },
  { "romainl/Apprentice" },
  { "shaunsingh/solarized.nvim" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "+Test",
  t = { "<cmd>TestNearest<cr>", "Nearest" },
  f = { "<cmd>TestFile<cr>", "File" },
  s = { "<cmd>TestSuite<cr>", "Suite" },
  l = { "<cmd>TestLast<cr>", "Last" },
  g = { "<cmd>TestVisit<cr>", "Visit" },
}

lvim.builtin.which_key.mappings["X"] = {
  name = "Files",
  X = { '<cmd>let @+=expand("%")<cr>', "Copy relative path" },
  p = { '<cmd>let @+=expand("%:p")<cr>', "Copy absolute path" },
  f = { '<cmd>let @+=expand("%:t")<cr>', "Copy filename" },
  d = { '<cmd>let @+=expand("%:p:h")<cr>', "Copy directory" },
}

function GrepInputStringImmediately()
  local default = vim.api.nvim_eval([[expand("<cword>")]])
  require("telescope.builtin").grep_string({ search = default })
end

lvim.builtin.which_key.mappings["F"] = { "<cmd>lua GrepInputStringImmediately()<CR>", "Grep Text under cursor" }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

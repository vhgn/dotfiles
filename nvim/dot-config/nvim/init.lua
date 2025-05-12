----------------------------------------
-- Random
----------------------------------------

-- Per project vimrc
vim.cmd([[set exrc]])
vim.cmd([[set secure]])

vim.g.moonflyTransparent = 1

vim.g.mapleader = "'"

vim.keymap.set("n", "<BS><BS>", ":below G<CR>")
vim.keymap.set("v", "<BS><BS>", ":below G<CR>")

vim.keymap.set("n", "<BS>f", ":diffget //2<CR>")
vim.keymap.set("v", "<BS>f", ":diffget //2<CR>")
vim.keymap.set("n", "<BS>j", ":diffget //3<CR>")
vim.keymap.set("v", "<BS>j", ":diffget //3<CR>")

vim.keymap.set("v", "<C-y>", '"*y')

vim.filetype.add({
  extension = {
    livemd = "markdown",
  },
})

----------------------------------------
-- Treesitter
----------------------------------------
local function treesitter_config()
  local configs = require("nvim-treesitter.configs")

  configs.setup({
    modules = {},
    ignore_install = {},
    ensure_installed = {
      "bash",
      "comment",
      "css",
      "html",
      "javascript",
      "jsdoc",
      "jsonc",
      "lua",
      "markdown",
      "regex",
      "scss",
      "toml",
      "typescript",
      "yaml",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    injection_queries = {},
  })
end

----------------------------------------
-- Livecommand
----------------------------------------
local function live_command_config()
  require("live-command").setup({
    commands = {
      Norm = {
        cmd = "norm",
      },
    },
  })
end

----------------------------------------
-- Telescope
----------------------------------------
local function telescope_config()
  local telescope = require("telescope")
  local lga_actions = require("telescope-live-grep-args.actions")

  telescope.setup({
    pickers = {
      find_files = {
        theme = "dropdown",
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
      live_grep = {
        theme = "dropdown",
      },
      quickfix = {
        theme = "dropdown",
      },
      commands = {
        theme = "dropdown",
      },
      lsp_dynamic_workspace_symbols = {
        theme = "dropdown",
      },
      git_branches = {
        theme = "dropdown",
      },
      current_buffer_fuzzy_find = {
        theme = "dropdown",
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = {         -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob *" }),
            -- freeze the current list and start a fuzzy search in the frozen list
            ["<C-space>"] = lga_actions.to_fuzzy_refine,
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      }
    }
  })


  ----------------------------------------
  -- Telescope
  ----------------------------------------
  local builtin = require("telescope.builtin")
  local config = require("telescope.config")
  telescope.load_extension("dap")
  telescope.load_extension("ui-select")
  telescope.load_extension("live_grep_args")


  local extensions = telescope.extensions

  local quickfix_files = function()
    local qflist = vim.fn.getqflist()
    local files = {}
    local seen = {}
    for k in pairs(qflist) do
      local path = vim.fn.bufname(qflist[k]["bufnr"])
      if not seen[path] then
        files[#files + 1] = path
        seen[path] = true
      end
    end
    table.sort(files)
    return files
  end

  local grep_on_quickfix = function()
    local args = {}

    for i, v in ipairs(config.values.vimgrep_arguments) do
      args[#args + 1] = v
    end
    for i, v in ipairs(quickfix_files()) do
      args[#args + 1] = "-g/" .. v
    end

    builtin.live_grep({ vimgrep_arguments = args })
  end

  vim.keymap.set("n", "zr", builtin.resume, {})
  vim.keymap.set("n", "zf", builtin.find_files, {})
  vim.keymap.set("n", "zg", builtin.live_grep, {})
  vim.keymap.set("n", "zG", grep_on_quickfix, {})

  -- Debugging
  vim.keymap.set("n", "zdb", extensions.dap.list_breakpoints, {})
  vim.keymap.set("n", "zdf", extensions.dap.frames, {})

  vim.keymap.set("n", "zF", extensions.live_grep_args.live_grep_args, {})

  vim.keymap.set("n", "zx", builtin.commands, {})
  vim.keymap.set("n", "zS", builtin.lsp_dynamic_workspace_symbols, {})
  vim.keymap.set("n", "zs", builtin.lsp_document_symbols, {})
  vim.keymap.set("n", "zb", builtin.git_branches, {})
  vim.keymap.set("n", "zc", builtin.current_buffer_fuzzy_find, {})
  -- Visual mode alternatives
  vim.keymap.set("v", "zg", '"zy:Telescope live_grep default_text=<C-r>z<cr>', {})
  vim.keymap.set("v", "zx", builtin.commands, {})
end

----------------------------------------
-- Gitsigns
----------------------------------------
local gitsigns_opts = {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "x" },
    topdelete = { text = "X" },
    changedelete = { text = "~" },
    untracked = { text = "*" },
  },
  signs_staged = {
    add = { text = "[" },
    change = { text = "[" },
    delete = { text = "[" },
    topdelete = { text = "[" },
    changedelete = { text = "[" },
    untracked = { text = "[" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  -- yadm = {
  -- 	enable = false,
  -- },
}
----------------------------------------
-- Lualine
----------------------------------------
local lualine_opts = {
  options = {
    icons_enabled = false,
    theme = "auto",
    section_separators = "",
    component_separators = "/",
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = {
      "branch",
      "diff",
      "diagnostics",
    },
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 2,
      },
    },
    lualine_z = {},
    lualine_y = {},
    lualine_x = {},
  },
  extensions = { "quickfix", "fugitive", "fzf" },
}

----------------------------------------
-- Colorscheme
----------------------------------------
local function moonfly_init()
  vim.cmd("colorscheme moonfly")
  vim.cmd("hi clear MoonflyTurquoise")
  vim.cmd("hi TreesitterContext guibg=#222222")
end

--------------------------------------
-- General
--------------------------------------

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.opt.showmode = false
vim.opt.scrolloff = 8

vim.opt.number = true
vim.opt.relativenumber = true

local TAB_WIDTH = 4
vim.o.expandtab = false
vim.o.tabstop = TAB_WIDTH
vim.o.shiftwidth = TAB_WIDTH
vim.o.shortmess = "IF"
vim.o.autowriteall = true

vim.opt.listchars = { tab = ">>", trail = "~", extends = ">", precedes = "<", space = "·" }
vim.opt.list = false
vim.opt.autoread = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.g.moonflyVirtualTextColor = true
vim.g.moonflyUnderlineMatchParen = true
vim.g.moonflyWinSeparator = 2
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- Autosave on fucus lost
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command = "silent! wa",
})

--------------------------------------
-- Plugins
--------------------------------------
local plugins = {
  -- Others
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",

  -- Neovim autocompletion
  "mfussenegger/nvim-dap",
  { "rcarriga/nvim-dap-ui",    dependencies = "nvim-neotest/nvim-nio" },
  "jay-babu/mason-nvim-dap.nvim",
  "mxsdev/nvim-dap-vscode-js",

  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- TypeScript
          null_ls.builtins.formatting.prettier,
          -- Python
          -- null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.black,
          -- -- OCaml
          -- null_ls.builtins.formatting.ocamlformat,
          -- -- Lua
          -- null_ls.builtins.formatting.stylua,
          -- -- Nix
          -- null_ls.builtins.code_actions.statix,
          -- null_ls.builtins.diagnostics.deadnix,
          -- -- Golang
          -- null_ls.builtins.formatting.gofmt,
          -- -- Gleam
          -- null_ls.builtins.formatting.gleam_format,
        },
      })
    end,
  },
  { "j-hui/fidget.nvim",       opts = {} },

  -- version control
  { "lewis6991/gitsigns.nvim", opts = gitsigns_opts },
  "tpope/vim-fugitive",

  -- navigation
  { "nvim-telescope/telescope.nvim",               config = telescope_config },
  { "nvim-telescope/telescope-dap.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },

  "ThePrimeagen/harpoon",
  { "nvim-lualine/lualine.nvim", opts = lualine_opts },
  "tpope/vim-repeat",

  -- shortcuts
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-eunuch",
  "tpope/vim-vinegar",
  "tpope/vim-dotenv",
  "tpope/vim-dispatch",
  "tpope/vim-dadbod",

  -- tools
  { "smjonas/live-command.nvim", config = live_command_config },
  "ThePrimeagen/vim-be-good",
  "nvim-lua/plenary.nvim",
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
  },
  {
    "kopecmaciej/vi-mongo.nvim",
    config = function()
      require("vi-mongo").setup()
    end,
    cmd = { "ViMongo" },
    keys = {
      { "<Leader>vm", "<cmd>ViMongo<cr>", desc = "ViMongo" },
    },
  },

  -- languages
  { "nvim-treesitter/nvim-treesitter",         config = treesitter_config, build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context", opts = {} },

  -- color theme
  { "bluz71/vim-moonfly-colors",               init = moonfly_init,        name = "moonfly",   lazy = false, priority = 1000 },
}

----------------------------------------
-- Lazy
----------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)



local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")

vim.keymap.set("n", "mv", harpoon_ui.toggle_quick_menu, {})
vim.keymap.set("n", "<C-j>", function()
  harpoon_ui.nav_file(1)
end, {})
vim.keymap.set("n", "<C-k>", function()
  harpoon_ui.nav_file(2)
end, {})
vim.keymap.set("n", "<C-l>", function()
  harpoon_ui.nav_file(3)
end, {})
vim.keymap.set("n", "mc", harpoon_mark.add_file, {})

----------------------------------------
-- LSP
----------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

local kind_icons = {
  Text = "...",
  Method = "M()",
  Function = "f()",
  Constructor = "New",
  Field = "[f]",
  Variable = "var",
  Class = "C{}",
  Interface = "I{}",
  Module = "[M]",
  Property = "(p)",
  Unit = "un.",
  Value = "123",
  Enum = "E{}",
  Keyword = "key",
  Snippet = "</>",
  Color = "rgb",
  File = "<f>",
  Reference = "& r",
  Folder = "<d>",
  EnumMember = "E.B",
  Constant = "VAR",
  Struct = "S{}",
  Event = "*ev",
  Operator = "+-=",
  TypeParameter = "<T>",
}

cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      -- This concatenates the icons with the name of the item kind
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.kind = kind_icons[vim_item.kind]

      vim_item.menu = ({
        buffer = "[buf]",
        nvim_lsp = "[lsp]",
        luasnip = "[snp]",
        nvim_lua = "[lua]",
        latex_symbols = "[tex]",
      })[entry.source.name]
      return vim_item
    end,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.complete(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})


require("mason").setup()
require("mason-nvim-dap").setup({
  automatic_installation = false,
  ensure_installed = {
    -- Due to a bug with the latest version of vscode-js-debug, need to lock to specific version
    -- See: https://github.com/mxsdev/nvim-dap-vscode-js/issues/58#issuecomment-2213230558
    -- "js@v1.76.1",
    "js"
  },
  handlers = {},
})

vim.cmd([[highlight DapBreakpoint ctermbg=0 guifg=0 guibg=#303659]])
vim.cmd([[highlight DapLogPoint ctermbg=0 guifg=0 guibg=#355930]])
vim.cmd([[highlight DapStopped ctermbg=0 guifg=0 guibg=#593430]])

vim.fn.sign_define(
  "DapBreakpoint",
  { text = ">", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "=", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "!", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

local dap = require("dap")

---@diagnostic disable-next-line: missing-fields
require("dap-vscode-js").setup({
  adapters = { "pwa-node", }, -- "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
  debugger_path = vim.fn.expand("~/Others/vscode-js-debug"),
  debugger_cmd = { "js-debug-adapter" }
})

require("dap").adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { vim.fn.expand("~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"), "${port}" },
  }
}


---@diagnostic disable-next-line: undefined-field
-- dap.configurations.typescript = {
-- 	{
-- 		type = "pwa-node",
-- 		request = "launch",
-- 		name = "Debug Jest Tests",
-- 		-- trace = true, -- include debugger info
-- 		runtimeExecutable = "node",
-- 		runtimeArgs = {
-- 			"./node_modules/jest/bin/jest.js",
-- 			"--runInBand",
-- 		},
-- 		rootPath = "${workspaceFolder}",
-- 		cwd = "${workspaceFolder}",
-- 		console = "integratedTerminal",
-- 		internalConsoleOptions = "neverOpen",
-- 	},
-- 	{
-- 		type = "pwa-node",
-- 		request = "launch",
-- 		name = "Launch file",
-- 		program = "${file}",
-- 		cwd = "${workspaceFolder}",
-- 	},
-- 	{
-- 		type = "pwa-node",
-- 		request = "attach",
-- 		name = "Attach",
-- 		processId = require("dap.utils").pick_process,
-- 		cwd = "${workspaceFolder}",
-- 	},
-- }
-- dap.adapters.chrome = {
-- 	type = "executable",
-- 	command = "node",
-- 	args = { os.getenv("HOME") .. "/Others/vscode-chrome-debug/out/src/chromeDebug.js" },
-- }

---@diagnostic disable-next-line: undefined-field
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return "/opt/homebrew/bin/python3"
    end,
  },
}
local dapui = require("dapui")
dapui.setup({
  controls = {
    element = "repl",
    enabled = true,
    icons = {
      disconnect = "[dis]",
      pause = "[pause]",
      play = "[play]",
      run_last = "[last]",
      step_back = "[back]",
      step_into = "[into]",
      step_out = "[out]",
      step_over = "[over]",
      terminate = "[term]"
    }
  },
  element_mappings = {},
  expand_lines = true,
  floating = {
    border = "single",
    mappings = {
      close = { "q", "<Esc>" }
    }
  },
  force_buffers = true,
  icons = {
    collapsed = "(>)",
    current_frame = "{>}",
    expanded = "(v)"
  },
  layouts = {
    {
      position = "bottom",
      size = 5,
      elements = {
        -- {
        --   id = "breakpoints",
        --   size = 0.2
        -- },
        {
          id = "watches",
          size = 0.5
        },
        {
          id = "repl",
          size = 0.5
        },
      },
    },
    {
      position = "bottom",
      size = 15,
      elements = {
        {
          id = "stacks",
          size = 0.5
        },
        {
          id = "scopes",
          size = 0.5
        },
      },
    },
    {
      position = "bottom",
      size = 20,
      elements = {
        {
          id = "console",
          size = 1
        }
      },
    }
  },
  mappings = {
    edit = "e",
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    repl = "r",
    toggle = "t"
  },
  render = {
    indent = 1,
    max_value_lines = 100
  }
})
-- Auto open and close on debugger attached
-- dap.listeners.before.attach.dapui_config = function()
--   dapui.open()
-- end
-- dap.listeners.before.launch.dapui_config = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated.dapui_config = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--   dapui.close()
-- end

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

vim.keymap.set("n", "<Leader>db", function()
  require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set("n", "<Leader>dd", function()
  require("dap").clear_breakpoints()
end)
vim.keymap.set("n", "<Leader>de", function()
  require("dap").set_exception_breakpoints()
end)
vim.keymap.set("n", "<Leader>dr", function()
  require("dap.repl").open()
end)
vim.keymap.set("n", "<Leader>dl", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end)
vim.keymap.set("n", "<Leader>dc", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<Leader>dC", function()
  require("dap").run_to_cursor()
end)
vim.keymap.set("n", "<Leader>ds", function()
  print("Terminating...")
  require("dap").terminate({}, {}, function()
    print("Terminated!")
  end)
end)
vim.keymap.set("n", "<Leader>du", function()
  require("dapui").toggle()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end)
vim.keymap.set("n", "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>dH", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)

local on_attach = function(_, bufnr)
  -- Change later
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = false, buffer = bufnr }

  -- Already default
  -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Default is <C-s>
  -- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

  vim.keymap.set("n", "zq", vim.diagnostic.setqflist, opts)

  vim.keymap.set("n", "gr", vim.lsp.buf.rename)
  vim.keymap.set({ "v", "n" }, "ga", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "ge", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

  vim.keymap.set("n", "<2-LeftMouse>", vim.lsp.buf.definition, opts)

  local format_fn = function()
    vim.lsp.buf.format({
      bufnr = bufnr,
      timeout_ms = 3000,
    })
  end
  vim.keymap.set("n", "#", format_fn, opts)
  vim.keymap.set("v", "#", format_fn, opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- To use in .nvim.lua
vim.lspconfig = {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
  ["lua_ls"] = function()
    require("lspconfig").lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          telemetry = { enable = false },
          diagnostics = {
            globals = { "vim", "require", "pcall", "pairs" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          completion = {
            workspaceWord = true,
            callSnippet = "Replace",
          },
          hint = {
            enable = true,
          },
          format = {
            enable = true,
          },
        },
      },
    })
  end,
  ["elixirls"] = function()
    require("lspconfig").elixirls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "elixir-ls" },
    })
  end,
  ["ts_ls"] = function()
    local init_options = {
      preferences = {
        importModuleSpecifierPreference = "absolute",
        importModuleSpecifierEnding = "minimal",
        disableAutomaticTypeAcquisition = true
      },
    }

    require("lspconfig").ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      init_options = init_options,
    })
  end,
  ["tailwindcss"] = function()
    require("lspconfig").tailwindcss.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "rust",
        "heex",
        "eelixir",
        "elixir",
      },
      init_options = {
        userLanguages = {
          elixir = "html-eex",
          eelixir = "html-eex",
          heex = "html-eex",
        },
      },
    })
  end,
  ["zls"] = function()
    -- don't show parse errors in a separate window
    vim.g.zig_fmt_parse_errors = 0
    -- disable format-on-save from `ziglang/zig.vim`
    vim.g.zig_fmt_autosave = 0

    require("lspconfig").zls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "/Users/vahagn/.local/share/nvim/mason/bin/zls" },
      settings = {
        zls = {

          -- Whether to enable build-on-save diagnostics
          --
          -- Further information about build-on save:
          -- https://zigtools.org/zls/guides/build-on-save/
          enable_build_on_save = false,
          zig_exec_path = "/usr/local/opt/zig/bin/zig"
        }
      }
    }
  end
})

vim.fn.sign_define("DiagnosticSignError", { text = "e", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "w", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = "?", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "i", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })

vim.diagnostic.config({
  virtual_text = { prefix = "", spacing = 10 },
  severity_sort = true,
  float = {
    source = "if_many",
  },
})

-- add border to lsp float windows
local _border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = _border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = _border,
})

vim.diagnostic.config({
  float = { border = "rounded" },
})

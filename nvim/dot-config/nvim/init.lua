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

vim.keymap.set("n", "<C-;>", ":noh<CR>")
vim.keymap.set("n", "<C-'>", ":sp<CR>:term<CR>ipython3<CR>")

vim.keymap.set("n", "<Leader>fm", ":Make!<CR>")

vim.filetype.add({
	extension = {
		livemd = "markdown",
	},
})

----------------------------------------
-- Python notebooks
----------------------------------------

--- TODO

local function otter_config()
	-- local otter = require("otter")
	-- otter.setup({
	-- 	verbose = {
	-- 		no_code_found = false,
	-- 	},
	-- })
	-- otter.activate()
end

----------------------------------------
-- Terminal
----------------------------------------
local function imagenvim_config()
	require("image").setup({
		backend = "kitty",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "vimwiki", "livemd", "quarto" },
			},
			neorg = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "norg" },
			},
			html = {
				enabled = false,
			},
			css = {
				enabled = false,
			},
		},
		max_width = nil,
		max_height = nil,
		max_width_window_percentage = 80,
		max_height_window_percentage = 80,
		window_overlap_clear_enabled = false,                                         -- toggles images when windows are overlapped
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		editor_only_render_when_focused = false,                                      -- auto show/hide images when the editor gains/looses focus
		tmux_show_only_in_active_window = false,                                      -- auto show/hide images in the correct Tmux window (needs visual-activity off)
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
	})
end
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
local telescope_opts = {
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
vim.o.shortmess = "I"
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

-- Quickfix
vim.keymap.set("n", "zj", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "zk", ":cprev<CR>", { silent = true })
vim.keymap.set("n", "zl", ":cclose<CR>", { silent = true })

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
	{
		"vhyrro/luarocks.nvim",
		priority = 1001, -- this plugin needs to run before anything else
		opts = {
			rocks = { "magick", "lua-cjson" },
		},
	},

	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",

	-- Neovim autocompletion
	"folke/neodev.nvim",
	"mfussenegger/nvim-dap",
	{ "rcarriga/nvim-dap-ui",    dependencies = "nvim-neotest/nvim-nio" },
	"jay-babu/mason-nvim-dap.nvim",
	"mxsdev/nvim-dap-vscode-js",
	"aznhe21/actions-preview.nvim",

	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- TypeScript
					-- null_ls.builtins.formatting.prettier,
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
	"j-hui/fidget.nvim",
	{
		"0x00-ketsu/maximizer.nvim",
		config = function()
			require("maximizer").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	},

	-- version control
	{ "lewis6991/gitsigns.nvim", opts = {} },
	"tpope/vim-fugitive",

	-- navigation
	{ "nvim-telescope/telescope.nvim", opts = telescope_opts },
	"ThePrimeagen/harpoon",
	{ "nvim-lualine/lualine.nvim",     opts = lualine_opts },
	"tpope/vim-repeat",

	-- shortcuts
	"tpope/vim-surround",
	"tpope/vim-commentary",
	"tpope/vim-eunuch",
	"tpope/vim-vinegar",
	"tpope/vim-dotenv",
	"tpope/vim-dispatch",
	"tpope/vim-projectionist",
	"tpope/vim-dadbod",

	-- tools
	{ "smjonas/live-command.nvim",       config = live_command_config },
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
		"3rd/image.nvim",
		config = imagenvim_config,
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
	{ "nvim-treesitter/nvim-treesitter", config = treesitter_config,  build = ":TSUpdate" },
	"nvim-treesitter/nvim-treesitter-context",
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = otter_config,
	},

	-- color theme
	{ "bluz71/vim-moonfly-colors", init = moonfly_init, name = "moonfly", lazy = false, priority = 1000 },
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

----------------------------------------
-- Telescope
----------------------------------------
local builtin = require("telescope.builtin")
local config = require("telescope.config")

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

vim.keymap.set("n", "zf", builtin.find_files, {})
vim.keymap.set("n", "zg", builtin.live_grep, {})
vim.keymap.set("n", "zG", grep_on_quickfix, {})
vim.keymap.set("n", "zd", builtin.quickfix, {})
vim.keymap.set("n", "zx", builtin.commands, {})
vim.keymap.set("n", "zs", builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set("n", "zb", builtin.git_branches, {})
vim.keymap.set("n", "zc", builtin.current_buffer_fuzzy_find, {})
-- Visual mode alternatives
vim.keymap.set("v", "zg", '"zy:Telescope live_grep default_text=<C-r>z<cr>', {})
vim.keymap.set("v", "zx", builtin.commands, {})

local maximizer = require("maximizer")
vim.keymap.set("n", "<C-w><C-o>", maximizer.toggle, {})
vim.keymap.set("v", "<C-w><C-o>", maximizer.toggle, {})

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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
	vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions)
	vim.keymap.set("n", "ge", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "<2-LeftMouse>", vim.lsp.buf.definition, opts)

	-- Default is <C-w>d
	-- vim.keymap.set("n", "[D", vim.diagnostic.open_float, opts)
	-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	local format_fn = function()
		vim.lsp.buf.format({
			bufnr = bufnr,
			timeout_ms = 3000,
		})
	end
	vim.keymap.set("n", "#", format_fn, opts)
	vim.keymap.set("v", "#", format_fn, opts)
end

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
	adapters = { "pwa-node",  }, -- "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
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
dapui.setup()

-- Auto open and close on debugger attached
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

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
	require("dap").terminate()
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
	["ts_ls"] = function()
		local init_options = {
			preferences = {
				importModuleSpecifierPreference = "relative",
				importModuleSpecifierEnding = "minimal",
			},
		}

		if file_exists("tsserverconfig.lua") then
			init_options = require("tsserverconfig")
		end

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
	["marksman"] = function()
		require("lspconfig").marksman.setup({
		})
	end,
})
require("lspconfig").gleam.setup({ on_attach = on_attach, capabilities = capabilities })

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

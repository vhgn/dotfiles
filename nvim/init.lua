-- Options {{{

-- Misc
vim.g.mapleader = "'"
vim.opt.background = "dark"
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.autocomplete = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.wrap = true

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Indentation
local TAB_WIDTH = 4
vim.opt.expandtab = false
vim.opt.tabstop = TAB_WIDTH
vim.opt.shiftwidth = TAB_WIDTH
vim.opt.softtabstop = TAB_WIDTH

-- Hidden characters
vim.opt.list = false
vim.opt.listchars = {
	tab = ">>",
	trail = "~",
	extends = ">",
	precedes = "<",
	space = "·",
}

-- Saving
vim.opt.shortmess = "IF"
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.backup = false

-- Other options
vim.g.moonflyTransparent = 1
vim.g.moonflyVirtualTextColor = true
vim.g.moonflyUnderlineMatchParen = true
vim.g.moonflyWinSeparator = 2
-- }}}

-- Autocmds {{{
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	command = "silent! wa",
})
-- }}}

-- Filetypes {{{
vim.filetype.add({
	extension = {
		livemd = "markdown",
	},
	filename = {
		Caddyfile = "caddy"
	}
})
-- }}}

-- Plugins {{{
vim.pack.add({
	-- Source control
	"https://github.com/tpope/vim-fugitive" ,
	"https://github.com/lewis6991/gitsigns.nvim" ,
	"https://github.com/sindrets/diffview.nvim" ,

	-- Debugger
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui" ,
	"https://github.com/nvim-neotest/nvim-nio" ,
	-- { src = "https://github.com/mxsdev/nvim-dap-vscode-js" },

	-- Navigation
	"https://github.com/nvim-telescope/telescope.nvim" ,
	"https://github.com/nvim-telescope/telescope-dap.nvim" ,
	"https://github.com/nvim-telescope/telescope-ui-select.nvim" ,
	"https://github.com/nvim-telescope/telescope-live-grep-args.nvim" ,
	"https://github.com/tpope/vim-vinegar" ,

	-- Editing
	"https://github.com/tpope/vim-surround" ,

	-- Utilities
	"https://github.com/nvim-lua/plenary.nvim" ,
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context" ,

	-- Interface
	"https://github.com/bluz71/vim-moonfly-colors" ,

	-- LSPs
	"https://github.com/neovim/nvim-lspconfig" ,
})
-- }}}

-- Colorscheme {{{

-- Treesitter
require("nvim-treesitter").setup({
	auto_install = true,
	ensure_installed = { "lua", "typescript", "javascript", "python", "gitcommit" },
	highlight = { enable = true },
	indent = { enable = true },
})

-- Colors
vim.cmd.colorscheme("moonfly")
vim.api.nvim_set_hl(0, "MoonflyTurquoise", {})
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#222222" })

-- LSP

vim.fn.sign_define({
	{ name = "DiagnosticSignError", text = "e", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" },
	{ name = "DiagnosticSignWarn",  text = "w", texthl = "DiagnosticSignWarn",  numhl = "DiagnosticSignWarn"  },
	{ name = "DiagnosticSignHint",  text = "?", texthl = "DiagnosticSignHint",  numhl = "DiagnosticSignHint"  },
	{ name = "DiagnosticSignInfo",  text = "i", texthl = "DiagnosticSignInfo",  numhl = "DiagnosticSignInfo"  },
})

-- }}}

-- LSPs {{{
vim.opt.completeopt = { "menuone", "noselect", "fuzzy", "popup", "nosort", "preview" }
vim.opt.complete = { ".", "w", "b", "u", "o" }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- if client and client.server_capabilities.semanticTokensProvider then
    --   vim.lsp.semantic_tokens.enable(true, { client_id = client.id })
    --   vim.lsp.semantic_tokens.force_refresh(bufnr)
    -- end

    if client and client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, bufnr)
    end
  end,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
-- }}}

-- Mappings {{{

-- Dap
local dap = require("dap")
local dapui = require("dapui")
local dapui_widgets = require("dap.ui.widgets")
vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set("n", "<Leader>dd", dap.clear_breakpoints)
vim.keymap.set("n", "<Leader>de", dap.set_exception_breakpoints)
vim.keymap.set("n", "<Leader>dr", require("dap.repl").open)
vim.keymap.set("n", "<Leader>dl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end)
vim.keymap.set("n", "<Leader>dc", dap.continue)
vim.keymap.set("n", "<Leader>dC", dap.run_to_cursor)
vim.keymap.set("n", "<Leader>ds", function()
	print("Terminating...")
	dap.terminate({}, {}, function()
		print("Terminated!")
	end)
end)
vim.keymap.set("n", "<Leader>du", dapui.toggle)
vim.keymap.set({ "n", "v" }, "<Leader>dh", dapui_widgets.hover)
vim.keymap.set("n", "<Leader>dp", dapui_widgets.preview)
vim.keymap.set("n", "<Leader>dH", function()
	dapui_widgets.centered_float(widgets.scopes)
end)

-- Git
vim.keymap.set("n", "<BS><BS>", ":below G<CR>")
vim.keymap.set("v", "<BS><BS>", ":below G<CR>")

vim.keymap.set("n", "<BS>f", ":diffget //2<CR>")
vim.keymap.set("v", "<BS>f", ":diffget //2<CR>")
vim.keymap.set("n", "<BS>j", ":diffget //3<CR>")
vim.keymap.set("v", "<BS>j", ":diffget //3<CR>")

vim.keymap.set("v", "<C-y>", '"*y')

-- Navigation

vim.keymap.set("n", "zf", ":Telescope find_files<CR>")
vim.keymap.set("n", "zg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "zr", ":Telescope resume<CR>")
vim.keymap.set("n", "zd", ":Telescope diagnostics<CR>")
vim.keymap.set("n", "zt", ":Telescope<CR>")

local telescope = require("telescope")
telescope.load_extension("dap")
telescope.load_extension("ui-select")
telescope.load_extension("live_grep_args")
-- vim.keymap.set("n", "zG", grep_on_quickfix, {})
--
-- -- Debugging
-- vim.keymap.set("n", "zdb", extensions.dap.list_breakpoints, {})
-- vim.keymap.set("n", "zdf", extensions.dap.frames, {})
--
-- vim.keymap.set("n", "zF", extensions.live_grep_args.live_grep_args, {})
--
vim.keymap.set("n", "zx", ":Telescope commands<CR>")
vim.keymap.set("n", "zS", ":Telescope lsp_dynamic_workspace_symbols<CR>")
vim.keymap.set("n", "zs", ":Telescope lsp_document_symbols<CR>")
vim.keymap.set("n", "zb", ":Telescope git_branches<CR>")
vim.keymap.set("n", "zc", ":Telescope current_buffer_fuzzy_find<CR>")
vim.keymap.set("v", "zg", '"zy:Telescope live_grep default_text=<C-r>z<cr>')
-- LSP
vim.keymap.set("n", "#", vim.lsp.buf.format)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<2-LeftMouse>", vim.lsp.buf.definition)
-- }}}

-- Debugging {{{
local dap = require("dap")
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { vim.fn.expand("~/Other/js-debug/src/dapDebugServer.js"), "${port}" },
	},
	-- skipFiles = {
	-- 	"<node_internals>/**",
	-- 	"**/node_modules/**/*",
	-- },
}
-- }}}

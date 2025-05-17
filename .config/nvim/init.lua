-------------------------------------------------------------------------------------------
--- LAZY BOOTSTRAP
-------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------------------
--- OPTIONS
-------------------------------------------------------------------------------------------

-- Set mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-------------------------------------------------------------------------------------------
--- FUNCTIONS
-------------------------------------------------------------------------------------------

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

local amap = function(keys, func, desc)
  vim.keymap.set({ 'n', 'v', 'i', 't' }, keys, func, { desc = desc })
end

-------------------------------------------------------------------------------------------
--- KEYMAPS
-------------------------------------------------------------------------------------------

-- Exit file
nmap("½", vim.cmd.Ex)

-- Binds alt+{h,j,k,l} to move window in all modes
amap('<A-h>', '<C-\\><C-N><C-w>h')
amap('<A-j>', '<C-\\><C-N><C-w>j')
amap('<A-k>', '<C-\\><C-N><C-w>k')
amap('<A-l>', '<C-\\><C-N><C-w>l')

-- Allow tab to swithc between tabs
nmap('<leader><Tab>', '<C-\\><C-N><C-w>:tabnext<Enter>')
nmap('<leader><S-Tab>', '<C-\\><C-N><C-w>:-tabnext<Enter>')

-- Open lazygit
nmap('<leader>g', '<C-\\><C-N>:LazyGit<Enter>')

-- Keybinds for netrw
vim.api.nvim_create_autocmd('filetype', {
	pattern = 'netrw',
	desc = 'Better mappings for netrw',
	callback = function()
		local bind = function(lhs, rhs)
			vim.keymap.set('n', lhs, rhs, { remap = true, buffer = true })
		end

		-- Move up directory
		bind('½', '-')
		bind('<leader><Tab>', ':tabnext<Enter>')
		bind('<leader><S-Tab>', ':-tabnext<Enter>')
	end
})

-------------------------------------------------------------------------------------------
--- lazy.vim
-------------------------------------------------------------------------------------------

require("lazy").setup({
    {
	'ellisonleao/gruvbox.nvim',
	priority = 1000,
	config   = true,
	opts     = ...
    },
    {
    	'kdheepak/lazygit.nvim',
	config = function()
		require("telescope").load_extension("lazygit")
	end,
    },
    {
	'nvim-telescope/telescope.nvim', 
	dependencies = 'nvim-lua/plenary.nvim'
    },
    {
	'nvim-telescope/telescope-fzf-native.nvim',
	build = 'make',
	cond = function() 
		return vim.fn.executable 'make' == 1
	end,
    },
    {
	'nvim-treesitter/nvim-treesitter',
	dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
	build = ':TSUpdate'
    },
    {
	'neovim/nvim-lspconfig',
	dependencies = 
	{
		'mason-org/mason.nvim',
		'mason-org/mason-lspconfig.nvim',
		'folke/neodev.nvim'
	}
    },
    {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'hrsh7th/cmp-nvim-lsp',
		'rafamadriz/friendly-snippets',
	},
    }
})

-------------------------------------------------------------------------------------------
--- Theme
-------------------------------------------------------------------------------------------

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-------------------------------------------------------------------------------------------
--- Telescope
-------------------------------------------------------------------------------------------

require('telescope').setup()

-- Enable telescope fzf native if installed
pcall(require('telescope').load_extension, 'fzf')

nmap('<leader>o',     require('telescope.builtin').oldfiles,   '[o] Find recently opened files')
nmap('<leader>b',     require('telescope.builtin').buffers,    '[b] Find existing buffers')
nmap('<leader>f',     require('telescope.builtin').git_files,  '[f] Search git files')
nmap('<leader>s',     require('telescope.builtin').find_files, '[s] Find files')
nmap('<leader><S-s>', require('telescope.builtin').live_grep,  '[S] Grep files')

-------------------------------------------------------------------------------------------
--- LSP
-------------------------------------------------------------------------------------------

nmap('<leader>r', vim.lsp.buf.rename,          '[r] Rename')
nmap('<leader>c', vim.lsp.buf.code_action,     '[c] Code Action')
nmap('<leader>d', vim.lsp.buf.definition,      '[d] Goto Definition')
nmap('<leader>D', vim.lsp.buf.declaration,     '[D] Goto Declaration')
nmap('<leader>i', vim.lsp.buf.implementation , '[i] Goto Implementation')

require('neodev').setup()
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = { 'clangd', 'lua_ls' } })

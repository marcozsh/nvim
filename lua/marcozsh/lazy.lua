vim.g.lazyvim_check_order = false
-- Bootstrap lazy.nvim
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

-- Configure lazy.nvim
require("lazy").setup({
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  
  -- Snacks.nvim (required by LazyVim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
  },

  -- Colorscheme mgz.nvim
  {
    'stankovictab/mgz.nvim',
  },

  -- Gruvbox colorscheme
  {
    'morhetz/gruvbox',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_contrast_dark = 'medium'  -- Opciones: 'soft', 'medium', 'hard'
      vim.g.gruvbox_contrast_light = 'medium'
      vim.cmd('colorscheme gruvbox')
      vim.o.background = 'dark'
    end,
  },

  -- Bufferline (barra superior de tabs/buffers)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",  -- Mostrar buffers en lugar de tabs
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 18,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          separator_style = "thin",  -- "slant", "thick", "thin", { 'any', 'any' }
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
          sort_by = 'insert_after_current',
        },
      })
    end,
  },

  
  -- Telescope (lazy load on command)
  {
    'nvim-telescope/telescope.nvim',
    -- Do not pin old tags on Neovim 0.11 (Treesitter API changed)
    cmd = "Telescope",
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      -- Leader mappings
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Telescope live grep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Telescope buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Telescope help tags' },

      -- Plain mappings (as requested)
      { 'ff', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files' },
      { 'fg', '<cmd>Telescope live_grep<cr>', desc = 'Telescope live grep' },
    },
  },
  -- Treesitter (NOTE: new nvim-treesitter rewrite does not support lazy-loading)
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- The new nvim-treesitter doesn't use require('nvim-treesitter.configs')
      -- Instead, it works directly with Neovim's built-in treesitter
      
      -- Enable treesitter highlighting automatically for common filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'lua',
          'vim',
          'vimdoc',
          'javascript',
          'typescript',
          'typescriptreact',
          'javascriptreact',
          'python',
          'go',
          'html',
          'css',
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- Treesitter context
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      local ok, treesitter_context = pcall(require, 'treesitter-context')
      if ok then
        treesitter_context.setup {
          enable = true,
          multiwindow = false,
          max_lines = 0,
          min_window_height = 0,
          line_numbers = true,
          multiline_threshold = 20,
          trim_scope = 'outer',
          mode = 'cursor',
          separator = nil,
          zindex = 20,
          on_attach = nil,
        }
      end
    end,
  },

  -- LSP + completion
  {
    'VonHeikemen/lsp-zero.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- LSP configs (for vim.lsp.config() to find server definitions)
      { 'neovim/nvim-lspconfig' },

      -- Installer UI
      { 'williamboman/mason.nvim' },
      -- Auto-install tools/servers
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      -- Mason setup
      require('mason').setup({})
      require('mason-tool-installer').setup({
        ensure_installed = {
          -- Match Mason package names (not always the same as lspconfig names)
          'lua-language-server',
          'rust-analyzer',
          'pyright',
          'angular-language-server',
          'typescript-language-server',
          'tailwindcss-language-server',
          'ocaml-lsp',
          'gopls',
          'golangci-lint',
        },
        auto_update = false,
        run_on_start = true,
      })

      vim.opt.signcolumn = 'yes'

      -- Add CMP capabilities to all LSP clients (Neovim 0.11 style)
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- Enable servers (Neovim 0.11+; avoids deprecated require('lspconfig') framework)
      vim.lsp.enable({
        'lua_ls',
        'rust_analyzer',
        'pyright',
        'angularls',
        'ts_ls',
        'tailwindcss',
        'gleam',
        'ocamllsp',
        'gopls',
      })

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
      })

      -- CMP setup
      local cmp = require('cmp')
      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Apply tailwind colors if the plugin is loaded
            local tailwind_ok, tailwind = pcall(require, 'tailwindcss-colorizer-cmp')
            if tailwind_ok then
              return tailwind.formatter(entry, vim_item)
            end
            return vim_item
          end
        },
      })
    end,
  },

  -- Lint (para Go, Rust, etc.)
  {
    'mfussenegger/nvim-lint',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        go = { 'golangcilint' },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Autopairs (load on insert)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

  -- UI plugins (load immediately for statusline)
  { 'vim-airline/vim-airline' },
  { 'vim-airline/vim-airline-themes' },

  -- NERDTree (lazy load on command) - DESACTIVADO: Reemplazado por nvim-tree
  -- {
  --   'preservim/nerdtree',
  --   cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
  --   init = function()
  --     -- NERDTree configuration (set before plugin loads)
  --     vim.g.NERDTreeWinSize = 100
  --     vim.g.NERDTreeDirArrowExpandable = '▸'
  --     vim.g.NERDTreeDirArrowCollapsible = '▾'
  --     vim.g.NERDTreeDirArrows = 1
  --     vim.g.NERDTreeShowLineNumbers = 1
  --     vim.g.NERDTreeQuitOnOpen = 1
  --     vim.g.NERDTreeWinPos = "right"
  --     vim.g.NERDTreeHighlightFoldersFullName = 1
  --     vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
  --     vim.g.DevIconsEnableFoldersOpenClose = 1
  --     vim.g.DevIconsEnableFolderExtensionPatternMatching = 1
  --     vim.g.webdevicons_conceal_nerdtree_brackets = 1
  --     -- Show folders with parentheses (for Next.js route groups)
  --     vim.g.NERDTreeRespectWildIgnore = 0
  --     vim.g.NERDTreeShowHidden = 1
  --     vim.g.NERDTreeIgnore = {}
  --     -- Ensure wildignore doesn't affect NERDTree
  --     vim.opt.wildignore = ""
  --
  --     -- Auto-open NERDTree if no files
  --     vim.api.nvim_create_autocmd("StdinReadPre", {
  --       pattern = "*",
  --       callback = function() vim.g.std_in = 1 end
  --     })
  --     vim.api.nvim_create_autocmd("VimEnter", {
  --       pattern = "*",
  --       callback = function()
  --         if vim.fn.argc() == 0 and not vim.g.std_in then
  --           vim.cmd("NERDTree")
  --         end
  --       end
  --     })
  --   end,
  --   config = function()
  --     -- Additional configuration after plugin loads
  --     vim.g.NERDTreeRespectWildIgnore = 0
  --     vim.g.NERDTreeShowHidden = 1
  --     vim.g.NERDTreeIgnore = {}
  --   end,
  -- },

  -- nvim-tree.lua (alternativa moderna a NERDTree)
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,  -- Cargar al inicio para que auto-open funcione
    priority = 1000,  -- Cargar temprano
    config = function()
      require("nvim-tree").setup({
        -- Deshabilitar netrw (explorador de archivos nativo de vim)
        disable_netrw = true,
        hijack_netrw = true,
        
        -- Configuración de vista
        view = {
          width = 100,
          side = "right",
          number = true,
          relativenumber = true,
        },
        
        -- Renderizado
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              folder = {
                arrow_closed = "▸",
                arrow_open = "▾",
              },
            },
          },
          highlight_opened_files = "all",
        },
        
        -- Acciones
        actions = {
          open_file = {
            quit_on_open = true,  -- Equivalente a NERDTreeQuitOnOpen
          },
        },
        
        -- Filtros (mostrar archivos ocultos y carpetas con paréntesis)
        filters = {
          dotfiles = false,  -- Mostrar archivos ocultos (equivalente a NERDTreeShowHidden)
          custom = {},       -- Sin filtros personalizados
        },
        
        -- Git integration
        git = {
          enable = true,
          ignore = false,
        },
        
        -- Auto-abrir cuando no hay archivos
        hijack_cursor = false,
      })
      
      -- Auto-open nvim-tree si no hay archivos (equivalente a NERDTree auto-open)
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function(data)
          -- Buffer is a real file on the disk
          local real_file = vim.fn.filereadable(data.file) == 1
          
          -- Buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1
          
          -- Si no hay argumentos (nvim sin archivos), abrir nvim-tree
          if not real_file and not directory and vim.fn.argc() == 0 then
            vim.cmd("NvimTreeOpen")
          end
        end
      })
    end,
  },

  -- Lazygit (lazy load on command)
  {
    'kdheepak/lazygit.nvim',
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Copilot (lazy load on insert)
  {
    'github/copilot.vim',
    event = "InsertEnter",
  },

  -- CopilotChat (lazy load on command)
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup {}
    end,
  },

  -- Indent blankline (lazy load on buffer)
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup({ indent = { highlight = highlight } })
    end,
  },

  -- Rainbow delimiters (lazy load on buffer)
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  -- Devicons (load early for other plugins)
  { 'ryanoasis/vim-devicons' },

  -- Tailwind CSS colorizer for nvim-cmp
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
    opts = {},
  },

  -- CSS color (lazy load on css files)
  {
    'ap/vim-css-color',
    ft = { "css", "scss", "sass", "less", "html" },
  },

  -- Emmet (lazy load on insert for web files)
  {
    'mattn/emmet-vim',
    ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
  },

  -- TS autotag (lazy load on buffer)
  {
    'windwp/nvim-ts-autotag',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
        per_filetype = {
          ["html"] = {
            enable_close = false,
          },
        },
      })
    end,
  },

  -- UFO folding (lazy load on buffer)
  {
    'kevinhwang91/nvim-ufo',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set('n', 'zk', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek Fold" })

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' }
        end
      })
    end,
  },

  -- Trouble (lazy load on command and keybindings)
  {
    'folke/trouble.nvim',
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {},
  },

}, {
  -- Lazy.nvim configuration
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

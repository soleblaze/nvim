local lazypath = vim.fn.stdpath("data") .. "/vscode/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)
local vscode = require("vscode-neovim")
vim.notify = vscode.notify

-- Settings
vim.g.mapleader = " "
vim.opt.grepprg = "rg"
vim.opt.wildmode = { "list", "longest" }

require("lazy").setup({
  root = vim.fn.stdpath("data") .. "/vscode",
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  init = function()
    require("nvim-treesitter.query_predicates")
  end,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      config = function()
        -- When in diff mode, we want to use the default
        -- vim text objects c & C instead of the treesitter ones.
        local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
        local configs = require("nvim-treesitter.configs")
        for name, fn in pairs(move) do
          if name:find("goto") == 1 then
            move[name] = function(q, ...)
              if vim.wo.diff then
                local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                for key, query in pairs(config or {}) do
                  if q == query and key:find("[%]%[][cC]") then
                    vim.cmd("normal! " .. key)
                    return
                  end
                end
              end
              return fn(q, ...)
            end
          end
        end
      end,
    },
  },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      },
    },
  },
  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@type table<string, boolean>
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}, {
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
  opts = {
    enable_autocmd = false,
  },
}, {
  "ggandor/leap.nvim",
  enabled = true,
  keys = {
    { "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
    { "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
    { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
  },
  config = function(_, opts)
    local leap = require("leap")
    for k, v in pairs(opts) do
      leap.opts[k] = v
    end
    leap.add_default_mappings(true)
    vim.keymap.del({ "x", "o" }, "x")
    vim.keymap.del({ "x", "o" }, "X")
  end,
}, {
  "ggandor/flit.nvim",
  enabled = true,
  keys = function()
    local ret = {}
    for _, key in ipairs({ "f", "F", "t", "T" }) do
      ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
    end
    return ret
  end,
  opts = { labeled_modes = "nx" },
}, {
  "echasnovski/mini.surround",
  opts = {
    mappings = {
      add = "gza", -- Add surrounding in Normal and Visual modes
      delete = "gzd", -- Delete surrounding
      find = "gzf", -- Find surrounding (to the right)
      find_left = "gzF", -- Find surrounding (to the left)
      highlight = "gzh", -- Highlight surrounding
      replace = "gzr", -- Replace surrounding
      update_n_lines = "gzn", -- Update `n_lines`
    },
  },
}, { "tpope/vim-repeat", event = "VeryLazy" }, {
  "echasnovski/mini.ai",
  -- keys = {
  --   { "a", mode = { "x", "o" } },
  --   { "i", mode = { "x", "o" } },
  -- },
  event = "VeryLazy",
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        d = { "%f[%d]%d+" }, -- digits
        e = { -- Word with case
          {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
          },
          "^().*()$",
        },
        g = function() -- Whole buffer, similar to `gg` and 'G' motion
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
      },
    }
  end,
}, {
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>up",
      function()
        vim.g.minipairs_disable = not vim.g.minipairs_disable
        if vim.g.minipairs_disable then
          vscode.notify("Disable auto pairs")
        else
          vscode.notify("Enable auto pairs")
        end
      end,
      desc = "Toggle Auto Pairs",
    },
  },
}, {
  "echasnovski/mini.surround",
  keys = function(_, keys)
    -- Populate the keys based on the user's options
    local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    local mappings = {
      { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
      { opts.mappings.delete, desc = "Delete Surrounding" },
      { opts.mappings.find, desc = "Find Right Surrounding" },
      { opts.mappings.find_left, desc = "Find Left Surrounding" },
      { opts.mappings.highlight, desc = "Highlight Surrounding" },
      { opts.mappings.replace, desc = "Replace Surrounding" },
      { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    }
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
}, {
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
  opts = {
    enable_autocmd = false,
  },
}, {
  "monaqa/dial.nvim",
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.new({
          elements = { "and", "or" },
          word = true,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { ">", "<" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "else", "elif" },
          word = true,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { ">", "<" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "on", "off" },
          word = true,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "yes", "no" },
          word = true,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { ">", "<" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "first", "last" },
          word = true,
          cyclic = true,
        }),
        augend.constant.alias.bool,
        augend.semver.alias.semver,
      },
      visual = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.semver.alias.semver,
        augend.constant.new({
          elements = { "-", "_" },
          word = false,
          cyclic = true,
        }),
      },
    })

    -- change augends in VISUAL mode
    vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
    vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
    vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
    vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
    vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
    vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
    vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
    vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
  end,
}, {
  "Wansmer/treesj",
  keys = {
    { "gJ", "<cmd>TSJToggle<cr>", desc = "Join Line" },
    { "gS", "<cmd>TSJSplit<cr>", desc = "Split Line" },
    { "gM", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
  },
  opts = { use_default_keymaps = false, max_join_length = 100 },
})

-- Keymaps
local keymap = vim.api.nvim_set_keymap

local function action(cmd)
  return string.format("<cmd>lua require('vscode-neovim').action('%s')<CR>", cmd)
end

keymap("n", "<leader>a", action("workbench.action.openQuickChat.copilot"), { silent = true })
keymap("n", "<leader>D", action("editor.action.revealDefinitionAside"), { silent = true })
keymap("n", "<leader>F", action("editor.action.formatDocument"), { silent = true })
keymap("n", "<leader>P", '"+P', { silent = true })
keymap("n", "<leader>d", action("workbench.action.closeWindow"), { silent = true })
keymap("n", "<leader>D", action("editor.action.showDefinitionPreviewHover"), { silent = true })
keymap("n", "<leader>e", action("problems.action.open"), { silent = true })
keymap("n", "<leader>ff", action("workbench.action.quickOpen"), { silent = true })
keymap("n", "<leader>fg", action("workbench.action.findInFiles"), { silent = true })
keymap("n", "<leader>fp", action("projectManager.listProjects"), { silent = true })
keymap("n", "<leader>fr", action("references-view.findReferences"), { silent = true })
keymap("n", "<leader>gb", action("gitlens.toggleFileBlame"), { silent = true })
keymap("n", "<leader>gd", action("editor.action.revealDefinition"), { silent = true })
keymap("n", "<leader>gi", action("editor.action.goToImplementation"), { silent = true })
keymap("n", "<leader>gl", action("extension.copyGitHubLinkToClipboard"), { silent = true })
keymap("n", "<leader>gr", action("editor.action.goToReferences"), { silent = true })
keymap("n", "<leader>gs", action("workbench.action.gotoSymbols"), { silent = true })
keymap("n", "<leader>gt", action("editor.action.goToTypeDefinition"), { silent = true })
keymap("n", "<leader>h", action("editor.action.showHover"), { silent = true })
keymap("n", "<leader>k", action("extension.dash.specific"), { silent = true })
keymap("n", "<leader>ls", action("workbench.action.showAllSymbols"), { silent = true })
keymap("n", "<leader>p", '"+p', { silent = true })
keymap("n", "<leader>rf", action("editor.action.refactor"), { silent = true })
keymap("n", "<leader>rn", action("editor.action.rename"), { silent = true })
keymap("n", "<leader>y", '"+y', { silent = true })
keymap("n", "[D", action("editor.action.marker.prevInFiles"), { silent = true })
keymap("n", "[d", action("editor.action.marker.prev"), { silent = true })
keymap("n", "]D", action("editor.action.marker.nextInFiles"), { silent = true })
keymap("n", "]d", action("editor.action.marker.next"), { silent = true })
keymap("n", "gc", "<Plug>VSCodeCommentary", { silent = true })
keymap("n", "gcc", "<Plug>VSCodeCommentaryLine", { silent = true })
keymap("o", "gc", "<Plug>VSCodeCommentary", { silent = true })
keymap("v", "<leader>y", '"+y', { silent = true })
keymap("v", "gc", "<Plug>VSCodeCommentary", { silent = true })
keymap("x", "gc", "<Plug>VSCodeCommentary", { silent = true })

return {
  {
    "zbirenbaum/copilot.lua",
    keys = {
      { "<leader>acd", "<cmd>Copilot disable<cr>", desc = "Disable Copilot" },
      { "<leader>acd", "<cmd>Copilot disable<cr>", desc = "Disable Copilot", mode = "v" },
      { "<leader>ace", "<cmd>Copilot enable<cr>", desc = "Enable Copilot" },
      { "<leader>ace", "<cmd>Copilot enable<cr>", desc = "Enable Copilot", mode = "v" },
      { "<leader>acp", "<cmd>Copilot panel<cr>", desc = "Copilot Panel" },
      { "<leader>acp", "<cmd>Copilot panel<cr>", desc = "Copilot Panel", mode = "v" },
      { "<leader>acs", "<cmd>Copilot status<cr>", desc = "Copilot Status" },
      { "<leader>acs", "<cmd>Copilot status<cr>", desc = "Copilot Status", mode = "v" },
      { "<leader>act", "<cmd>CopilotToggle<cr>", desc = "Toggle Copilot" },
      { "<leader>act", "<cmd>CopilotToggle<cr>", desc = "Toggle Copilot", mode = "v" },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
      debug = false,
      mode = "split",
      promts = {
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
      },
    },
    build = function()
      vim.defer_fn(function()
        vim.cmd("UpdateRemotePlugins")
        vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
      end, 3000)
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>av", "<cmd>CopilotChatVisual<cr>", desc = "CopilotChat - Visual", mode = "v" },
      { "<leader>ai", "<cmd>CopilotChatInPlace<cr>", desc = "CopilotChat - In-place", mode = { "n", "v" } },
    },
  },
}

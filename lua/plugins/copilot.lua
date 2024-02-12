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
      promts = {
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
      },
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      {
        "<leader>av",
        ":CopilotChatVisual",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ai",
        ":CopilotChatInPlace<cr>",
        mode = "x",
        desc = "CopilotChat - Run in-place code",
      },
    },
  },
}

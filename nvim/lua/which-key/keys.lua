local wk = require("which-key")
wk.register({
  f = {
    name = "Filesystem",
    e = "Toggle Neo-tree",
    f = "Find Files",
  },
  l = {
    name = "LSP",
    d = "Go to Definition",
    r = "Rename Symbol",
  },
}, { prefix = "<leader>" })

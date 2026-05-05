return {
  cmd = { "rust-analyzer" },
  rootmarkers = { "Cargo.lock", "Cargo.toml", ".git" },
  filetypes = { "rs", "rust" },
  settings = {
    ['rust-analyzer'] = {
      inlayHints = {
        -- These are a bit too much.
        chainingHints = { enable = true },
      },
    },
    single_file_support = true,
  }
}

cask "dasllama" do
  version "0.6.5-rc1"
  sha256 "5f64f03644a4ae74b6d9d5c80d110105c25b7cb5c51afba8ad658ab75bdf0b93"

  url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/dasllama-darwin-arm64.zip"
  name "dasllama"
  desc "OpenAI-compatible local LLM server with a menu bar supervisor"
  homepage "https://dasllama.io"

  depends_on arch: :arm64
  # the formula puts the same commands on PATH
  conflicts_with formula: "dasllama"

  # the app's launcher is the watchdog: it starts the server and puts the mark in the menu bar
  app "dasllama-server.app"
  binary "#{appdir}/dasllama-server.app/Contents/MacOS/dasllama-server"
  binary "#{appdir}/dasllama-server.app/Contents/MacOS/dasllama-cli"
  binary "#{appdir}/dasllama-server.app/Contents/MacOS/dasllama-bench"
  binary "#{appdir}/dasllama-server.app/Contents/MacOS/watchdog", target: "dasllama-watchdog"

  caveats <<~EOS
    The app is not code-signed: macOS asks once under
    System Settings > Privacy & Security before the first start.
  EOS
end

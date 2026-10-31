cask "dasllama" do
  version "0.6.7"
  sha256 "b6766a7abd7934bee56b84c0fbc0353cbfa7e07d870e512ec64971c25f38bec9"

  url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7/dasllama-darwin-arm64.zip"
  name "dasllama"
  desc "OpenAI-compatible local LLM server with a menu bar supervisor"
  homepage "https://dasllama.io"

  depends_on arch: :arm64

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

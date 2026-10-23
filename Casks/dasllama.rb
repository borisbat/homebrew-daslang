cask "dasllama" do
  version "0.6.6"
  sha256 "59532db93b61903dfcfa3e8e9ff5fb286386c4e81e7be233d9552b39c9169d2c"

  url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6/dasllama-darwin-arm64.zip"
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

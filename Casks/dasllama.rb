cask "dasllama" do
  version "0.6.7-rc2"
  sha256 "4091979b8af353559213ff6f44362db77718098ac9214289765c5e9fadabfc14"

  url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7-RC2/dasllama-darwin-arm64.zip"
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

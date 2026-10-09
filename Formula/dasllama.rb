class Dasllama < Formula
  desc "OpenAI-compatible local LLM server, CLI and benchmark over dasLLAMA"
  homepage "https://dasllama.io"
  version "0.6.6-rc1"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6-RC1/dasllama-darwin-arm64.zip"
      sha256 "03a27328fa374891cff5bc7f5f90161e0d929abe04f8f5c7991c020bf0277594"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6-RC1/dasllama-linux-x86_64.tar.gz"
      sha256 "9d3a20a613a8aeb6687cd5e6f75debe0b399affc9cc36944b739f26571f00bbb"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6-RC1/dasllama-linux-arm64.tar.gz"
      sha256 "bf26cf50dc07f65cc9f40ae89fc0edf29e7b70afa1d09a67c964cb2bced20618"
    end
  end

  # the tray app is the cask; both put the same commands on PATH
  conflicts_with cask: "dasllama"

  def install
    # the programs find their runtime beside themselves, so the tree stays together; brew
    # strips a sole top dir on unpack (dasllama-server/ on linux, the .app on a mac)
    libexec.install Dir["*"]
    if OS.mac?
      app = File.directory?(libexec/"Contents") ? libexec : libexec/"dasllama-server.app"
      exes = { "dasllama-server" => "dasllama-server", "dasllama-cli" => "dasllama-cli", "dasllama-bench" => "dasllama-bench", "dasllama-watchdog" => "watchdog" }
      exes.each { |cmd, exe| bin.install_symlink app/"Contents/MacOS"/exe => cmd }
    else
      exes = { "dasllama-server" => "dasllama-server.exe", "dasllama-cli" => "dasllama-cli.exe", "dasllama-bench" => "dasllama-bench.exe", "dasllama-watchdog" => "watchdog" }
      exes.each { |cmd, exe| bin.install_symlink libexec/exe => cmd }
    end
  end

  service do
    run [opt_bin/"dasllama-watchdog"]
    keep_alive false
    log_path var/"log/dasllama.log"
    error_log_path var/"log/dasllama.log"
  end

  test do
    assert_match "dasllama-cli", shell_output("#{bin}/dasllama-cli --help")
  end
end

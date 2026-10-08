class Dasllama < Formula
  desc "OpenAI-compatible local LLM server, CLI and benchmark over dasLLAMA"
  homepage "https://dasllama.io"
  version "0.6.5-rc1"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/dasllama-darwin-arm64.zip"
      sha256 "5f64f03644a4ae74b6d9d5c80d110105c25b7cb5c51afba8ad658ab75bdf0b93"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/dasllama-linux-x86_64.tar.gz"
      sha256 "87b12772f2a20d71ab71e89bd369f208d5e3b8a0bd88a384fe8c6d458f156363"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/dasllama-linux-arm64.tar.gz"
      sha256 "cec022b205d0de95d5f9a91c4f7df39fbcd0759495b571b5f60f852f170a9a4b"
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

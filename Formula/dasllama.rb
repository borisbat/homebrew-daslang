class Dasllama < Formula
  desc "OpenAI-compatible local LLM server, CLI and benchmark over dasLLAMA"
  homepage "https://dasllama.io"
  version "0.6.7-rc2"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7-RC2/dasllama-darwin-arm64.zip"
      sha256 "4091979b8af353559213ff6f44362db77718098ac9214289765c5e9fadabfc14"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7-RC2/dasllama-linux-x86_64.tar.gz"
      sha256 "ab2892ec8a1d77d7eacbfb071a0ca6d71a4b59350eaec9dc950d5f3318c414f5"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7-RC2/dasllama-linux-arm64.tar.gz"
      sha256 "8a785c7a204f9e5b3eed4f57ee522dff6067fbd51691fdc4f12bd31de17af2ea"
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

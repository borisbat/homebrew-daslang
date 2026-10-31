class Dasllama < Formula
  desc "OpenAI-compatible local LLM server, CLI and benchmark over dasLLAMA"
  homepage "https://dasllama.io"
  version "0.6.7"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7/dasllama-darwin-arm64.zip"
      sha256 "b6766a7abd7934bee56b84c0fbc0353cbfa7e07d870e512ec64971c25f38bec9"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7/dasllama-linux-x86_64.tar.gz"
      sha256 "b8a4a7337ad47d382a1fb7207f35ba8d47b16dceb4e741ccf6da5171303af4c3"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.7/dasllama-linux-arm64.tar.gz"
      sha256 "f6e08b7e03b037ac33fedf7b68d483e93ce49cd3c6d4f45872851e2b468168d2"
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

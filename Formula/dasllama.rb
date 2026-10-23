class Dasllama < Formula
  desc "OpenAI-compatible local LLM server, CLI and benchmark over dasLLAMA"
  homepage "https://dasllama.io"
  version "0.6.6"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6/dasllama-darwin-arm64.zip"
      sha256 "59532db93b61903dfcfa3e8e9ff5fb286386c4e81e7be233d9552b39c9169d2c"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6/dasllama-linux-x86_64.tar.gz"
      sha256 "67536fcb6e78643dff7f36460e8a289eaab531e1e5f5d254f8980c30638513b7"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/dasllama-v0.6.6/dasllama-linux-arm64.tar.gz"
      sha256 "0de689945ec5e08a5f11208d2394c93060f0837a7580d35639cc048d99c35dcc"
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

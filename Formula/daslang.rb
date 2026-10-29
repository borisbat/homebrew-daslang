class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.5-rc3"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC3/daslang-bundle-darwin26-arm64.zip"
      sha256 "494fe479f2e45db47b8f05d9cdff2dfc314363b5a76cdc09be882db32daa9449"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC3/daslang-bundle-linux-x86_64.zip"
      sha256 "d3a9324433fc98c85787faf209f026923f53cb1d936b931da0b4b38bf130c3b0"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC3/daslang-bundle-linux-arm64.zip"
      sha256 "a9fbdb0d8f8fff0646c01a41ff473a6d85fc7930b8f63ea00d2b65990cf7516b"
    end
  end

  def install
    # the bundle is a self-contained SDK tree; daslang derives its module root
    # from the executable location, so the tree must stay together. The zip
    # carries a top-level daslang_bundle/ dir; brew strips a sole top dir on
    # unpack, but stage from it explicitly in case that ever changes.
    root = File.directory?("daslang_bundle") ? "daslang_bundle" : "."
    libexec.install Dir["#{root}/*"]
    exes = { "daslang" => "bin/daslang", "daslang-live" => "bin/daslang-live", "lint" => "bin/lint.exe", "daspkg" => "bin/daspkg.exe", "dascov" => "bin/dascov.exe", "detect-dupe" => "bin/detect-dupe.exe", "benchctl" => "bin/benchctl.exe", "dastest" => "bin/dastest.exe", "das-fmt" => "bin/das-fmt.exe", "daslang-watchdog" => "bin/watchdog" }
    exes.each { |cmd, exe| bin.install_symlink libexec/exe => cmd }
  end

  test do
    (testpath/"hello.das").write <<~EOS
      [export]
      def main() {
          print("hello daslang\\n")
      }
    EOS
    assert_match "hello daslang", shell_output("#{bin}/daslang #{testpath}/hello.das")
  end
end

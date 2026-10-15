class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.5-rc2"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC2/daslang-bundle-darwin26-arm64.zip"
      sha256 "83460499e517ec9fdb7d0e05a213170e92f61ceca0370fa2e540f8aedcd4870b"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC2/daslang-bundle-linux-x86_64.zip"
      sha256 "e4959cebd0b7ee16d6737285a156de0e03c8c6d98b4d7ff674aaf70da936200d"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC2/daslang-bundle-linux-arm64.zip"
      sha256 "530d6ee08e2c86983c5ff1c07b4aa4ab5ab10405c6310a148e39bcbd6d61cfd0"
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

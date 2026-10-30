class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.5-rc4"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC4/daslang-bundle-darwin26-arm64.zip"
      sha256 "0de5c581897f84f670acc3737500730d07d2ed835951d09c8908ea4309553fa4"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC4/daslang-bundle-linux-x86_64.zip"
      sha256 "c2706ad47e6b0935d63be8ee54f8b7879ace522cf80f0da5179bbd92ce8699a5"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC4/daslang-bundle-linux-arm64.zip"
      sha256 "1a8ee88d146d98d898176a12d8099c1d2c914a8f5edf15212f0f2e3ee84f0008"
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

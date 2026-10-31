class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.5-rc5"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC5/daslang-bundle-darwin26-arm64.zip"
      sha256 "5071e5cec5bb10265c333f0214e910c401b746b0475300faf584050b89e8404d"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC5/daslang-bundle-linux-x86_64.zip"
      sha256 "2ded35e2789c19291c0e2a3fb178124e1c0d134f1301c8b5dd3d1e503f4883c5"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC5/daslang-bundle-linux-arm64.zip"
      sha256 "12d6b6dffe43a662dcea99cf051f9040d88110313927e954f8f8fe1e3165584b"
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

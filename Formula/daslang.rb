class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.5"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5/daslang-bundle-darwin26-arm64.zip"
      sha256 "dbc8dbe88273f33ee82641d2c8e4cb7aab4285b33ce6ef1e7eb8c7e01f5d8c14"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5/daslang-bundle-linux-x86_64.zip"
      sha256 "200729d7506a1d799f0c63d270ffa13f4c4409375a02e16d911c8e70e990ee2c"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5/daslang-bundle-linux-arm64.zip"
      sha256 "fba32436cc455c94fd86d9d410afe14ec31d688fc2a83b2762f9f998ce0df4db"
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

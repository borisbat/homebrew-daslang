class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.4"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4/daslang-bundle-darwin26-arm64.zip"
      sha256 "30c7674ed7717cc3cbd62182aa382866c5e5016d7260b9044d374a72ef8b8c78"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4/daslang-bundle-linux-x86_64.zip"
      sha256 "1f8fbd58dd2b99f98502f16a9c78d6f8edfcebd908b34accfa088b097e3e4e02"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4/daslang-bundle-linux-arm64.zip"
      sha256 "3022dc1e2e3fb911534e9cbc6a31a80967aef02a5a0b100748093b661fa16626"
    end
  end

  def install
    # the bundle is a self-contained SDK tree; daslang derives its module root
    # from the executable location, so the tree must stay together. The zip
    # carries a top-level daslang_bundle/ dir; brew strips a sole top dir on
    # unpack, but stage from it explicitly in case that ever changes.
    root = File.directory?("daslang_bundle") ? "daslang_bundle" : "."
    libexec.install Dir["#{root}/*"]
    bin.install_symlink libexec/"bin/daslang"
    bin.install_symlink libexec/"bin/daslang-live"
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

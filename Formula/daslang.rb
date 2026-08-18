class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.4-rc1"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC1/daslang-bundle-darwin26-arm64.zip"
      sha256 "f5f8423daa0b3b51e3d13cd3a18e640455c38c9b98b44ed360da9bcb0af55cd3"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC1/daslang-bundle-linux-x86_64.zip"
      sha256 "824b95bcf514fc7e40b0f34936da0a2fa230877cfae6c7877eb2601d996e5e44"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC1/daslang-bundle-linux-arm64.zip"
      sha256 "24349c7ec240f75f7bd491f31b99cf7e3c17f84cfb4d63f60013e317dfe6067b"
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
    bin.install_symlink libexec/"bin/gen1_to_gen2"
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

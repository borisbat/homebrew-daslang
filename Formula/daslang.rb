class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.5-rc1"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/daslang-bundle-darwin26-arm64.zip"
      sha256 "e7d32b6475db8cefc0b6cc195bc8392a00438e80d90d69597228412e44d728e2"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/daslang-bundle-linux-x86_64.zip"
      sha256 "35510da508ba673a32c855d97808da11e96b462765fa7b8ec1b3a4ab5ad2e887"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.5-RC1/daslang-bundle-linux-arm64.zip"
      sha256 "8924ddb2442cd417c6a9c2b3eea484681c605576823eb66509b7ee9baaf7c57f"
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

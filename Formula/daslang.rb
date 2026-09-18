class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.4-rc4"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC4/daslang-bundle-darwin26-arm64.zip"
      sha256 "955cf134db7e45dd83151ee23baffe496d5317c083a20438867e95be023d4655"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC4/daslang-bundle-linux-x86_64.zip"
      sha256 "fe8ac0d25364d0e209108176a1beb1056591481205059dfa72a18f38232ee20c"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC4/daslang-bundle-linux-arm64.zip"
      sha256 "cc499b2ee700eea0d11691e5a8c815a1ff443a88220bb29fd5bf8c8d7bc5e39f"
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

class Daslang < Formula
  desc "High-performance statically-typed scripting language for games and real-time applications"
  homepage "https://daslang.io"
  version "0.6.4-rc2"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC2/daslang-bundle-darwin26-arm64.zip"
      sha256 "4c8810219f172b6e3adfc9f12628ee851a943c305d3f816cbb00d4781ecb986d"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC2/daslang-bundle-linux-x86_64.zip"
      sha256 "a93f8ebb0be14a725a19cf64e268688b9849261fded5bd6169729f43413c4c76"
    end
    on_arm do
      url "https://github.com/GaijinEntertainment/daScript/releases/download/v0.6.4-RC2/daslang-bundle-linux-arm64.zip"
      sha256 "ccdf30bf3cc808cc524cd9a94765f80b2e2e2b7e016f35d2ed0c6521fa4d92b0"
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

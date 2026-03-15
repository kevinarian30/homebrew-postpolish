class PostPolish < Formula
  desc "An offline text reviewer for public posts, powered by small language models (SLMs)."
  homepage "https://github.com/kevinarian30/homebrew-postpolish"
  url "https://github.com/kevinarian30/homebrew-postpolish/releases/download/vbuild-20260315-596dad6/post-polish-brew-vbuild-20260315-596dad6.tar.gz"
  sha256 "7e5acbb7d0b9475ed51177d97be9243275682b1456fbd2f73e613a2aeab275bd"
  license "MIT"

  depends_on :macos

  def install
    bin.install "bin/postpolish"
    libexec.install Dir["libexec/*"]
    (share/"post-polish").install "share/seed-memory.json"
  end

  def post_install
    (var/"post-polish/model").mkpath
    (var/"post-polish/config").mkpath
    (var/"post-polish/memories").mkpath
    (var/"post-polish/logs").mkpath
    (var/"post-polish/run").mkpath
    cp share/"post-polish/seed-memory.json", var/"post-polish/memories/seed-memory.json"
    settings = var/"post-polish/config/settings.json"
    settings.write("{}") unless settings.exist?
  end

  def caveats
    <<~EOS
      PostPolish requires a local LLM model (2-7 GB download).

      First-time setup:
        postpolish setup

      Start the app:
        postpolish start

      Models are stored in: #{var}/post-polish/model/
    EOS
  end

  service do
    run [opt_bin/"postpolish", "start", "--foreground", "--no-browser"]
    keep_alive false
    log_path var/"log/post-polish.log"
    error_log_path var/"log/post-polish-error.log"
  end

  test do
    assert_match "PostPolish", shell_output("#{bin}/postpolish --version")
  end
end

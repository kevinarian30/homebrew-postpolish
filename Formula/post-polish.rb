class PostPolish < Formula
  desc "An offline text reviewer for public posts, powered by small language models (SLMs)."
  homepage "https://github.com/kevinarian30/homebrew-postpolish"
  url "https://github.com/kevinarian30/homebrew-postpolish/releases/download/vbuild-20260315-029aee7/post-polish-brew-vbuild-20260315-029aee7.tar.gz"
  sha256 "c5af7b106aabc0c6dea44ab4284e074bd076d7c9231b0ce3c23e2756b5fcc553"
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

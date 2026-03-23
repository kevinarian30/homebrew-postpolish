class Postpolish < Formula
  desc "An offline text reviewer for public posts, powered by small language models (SLMs)."
  homepage "https://github.com/kevinarian30/homebrew-postpolish"
  url "https://github.com/kevinarian30/homebrew-postpolish/releases/download/vuntagged-e1b014827ba13533ece3/post-polish-brew-vuntagged-e1b014827ba13533ece3.tar.gz"
  sha256 "d0f958daee403ebeb40d370e5b5c6b523aa389f5a94b7a8f6d15f252eccace23"
  license "MIT"

  depends_on :macos

  def install
    bin.install "bin/postpolish"
    libexec.install Dir["libexec/*"]
    (share/"postpolish").install "share/seed-memory.json"
  end

  def post_install
    (var/"postpolish/model").mkpath
    (var/"postpolish/config").mkpath
    (var/"postpolish/memories").mkpath
    (var/"postpolish/logs").mkpath
    (var/"postpolish/run").mkpath
    cp share/"postpolish/seed-memory.json", var/"postpolish/memories/seed-memory.json"
    settings = var/"postpolish/config/settings.json"
    settings.write("{}") unless settings.exist?
  end

  def caveats
    <<~EOS
      PostPolish requires a local LLM model (2-7 GB download).

      First-time setup:
        postpolish setup

      Start the app:
        postpolish start

      Models are stored in: #{var}/postpolish/model/
    EOS
  end

  service do
    run [opt_bin/"postpolish", "start", "--foreground", "--no-browser"]
    keep_alive false
    log_path var/"log/postpolish.log"
    error_log_path var/"log/postpolish-error.log"
  end

  test do
    assert_match "PostPolish", shell_output("#{bin}/postpolish --version")
  end
end

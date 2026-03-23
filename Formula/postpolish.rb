class Postpolish < Formula
  desc "An offline text reviewer for public posts, powered by small language models (SLMs)."
  homepage "https://github.com/kevinarian30/homebrew-postpolish"
  url "https://github.com/kevinarian30/homebrew-postpolish/releases/download/v1.0.9/post-polish-brew-v1.0.9.tar.gz"
  sha256 "bf0fec6392f21cee23c92672171a0ae6fa423c98cc3d45860e9aa5d5b3b46d1a"
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

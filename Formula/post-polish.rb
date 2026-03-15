class PostPolish < Formula
  desc "Offline grammar checker for English/Indonesian bilingual text"
  homepage "https://github.com/kevinarian30/homebrew-postpolish"
  url "https://github.com/kevinarian30/homebrew-postpolish/releases/download/v<VERSION>/post-polish-brew-v<VERSION>.tar.gz"
  sha256 "<SHA256>"
  license "MIT"

  depends_on :macos

  def install
    bin.install "bin/postpolish"
    libexec.install Dir["libexec/*"]
    (share/"post-polish").install "share/seed-memory.json"
  end

  def post_install
    # Create mutable data directories
    (var/"post-polish/model").mkpath
    (var/"post-polish/config").mkpath
    (var/"post-polish/memories").mkpath
    (var/"post-polish/logs").mkpath
    (var/"post-polish/run").mkpath

    # Initialize seed memory working copy
    cp share/"post-polish/seed-memory.json", var/"post-polish/memories/seed-memory.json"

    # Initialize settings.json if not present
    settings = var/"post-polish/config/settings.json"
    unless settings.exist?
      settings.write("{}")
    end
  end

  def caveats
    <<~EOS
      PostPolish requires a local LLM model (2-7 GB download).

      First-time setup:
        postpolish setup

      Start the app:
        postpolish start

      Or use brew services:
        brew services start post-polish

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
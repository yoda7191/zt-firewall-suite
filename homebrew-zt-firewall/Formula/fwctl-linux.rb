class FwctlLinux < Formula
  desc "ZeroTier-Aware Modular Firewall CLI (Linux)"
  homepage "https://github.com/yourusername/zt-firewall "
  url "https://github.com/yourusername/zt-firewall/releases/download/v1.0.0/zt-firewall-ubuntu-latest-x86_64.tar.gz "
  sha256 "YOUR_SHA_HERE"

  depends_on :linux

  def install
    bin.install "opt/zt-firewall/bin/fwctl" => "fwctl"
    prefix.install Dir["opt/zt-firewall/*"]
  end
end
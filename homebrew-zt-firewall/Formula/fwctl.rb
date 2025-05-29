class Fwctl < Formula
  desc "ZeroTier-Aware Modular Firewall CLI"
  homepage "https://github.com/yourusername/zt-firewall "
  url "https://github.com/yourusername/zt-firewall/releases/download/v1.0.0/zt-firewall-macos-aarch64.tar.gz "
  sha256 "YOUR_SHA_HERE"

  depends_on :macos

  def install
    bin.install "opt/zt-firewall/bin/fwctl" => "fwctl"
    prefix.install Dir["opt/zt-firewall/*"]
  end

  def post_install
    system "sudo fwctl set-rule zerotier-swarm"
  end

  def caveats
    <<~EOS
      Firewall installed! Run:
        sudo fwctl set-rule zerotier-swarm
    EOS
  end
end
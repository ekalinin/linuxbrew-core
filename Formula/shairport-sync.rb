class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.6.tar.gz"
  sha256 "a8382affd25c473fa38ead5690148c6c3902098f359f9c881eefe139e1f49f49"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "development"

  livecheck do
    url "https://github.com/mikebrady/shairport-sync/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "5e80cb769ab8c391af730a66ffd90dee2e810827edc232412c3f7e1ae2c4dbf3" => :big_sur
    sha256 "3c2a973fbbe200704e35737226fd4e7ed6edad9f389253602fe5d14c50bb171e" => :catalina
    sha256 "afe30af9e783c581888b525d7e3aab13e09e9812e9f717ad258c9cbb996da8a4" => :mojave
    sha256 "d08952f97ce3a3f7e10a602322d0fdb23d8553586b4a7ad6b01af927f9969e1f" => :high_sierra
    sha256 "ee1e38ff28ddc1a554159f72afe4cdcce10ac38760428298a1a5a867b678a97b" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pa
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    args << "--with-dns_sd" if OS.mac? # Disable bonjour in Linux
    args << "--with-os=darwin" if OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end

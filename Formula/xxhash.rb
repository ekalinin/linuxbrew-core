class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.0.tar.gz"
  sha256 "7054c3ebd169c97b64a92d7b994ab63c70dd53a06974f1f630ab782c28db0f4f"
  revision 1 unless OS.mac?
  license "BSD-2-Clause"

  livecheck do
    url "https://github.com/Cyan4973/xxHash/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "13fd891c5e884b86cd7273192bbea63d56e4f8f8c461009ee2050af09eeb2161" => :big_sur
    sha256 "06ea145c49451bf37f2a73139100f436b4bf9f275b77b9dadcb5d36a7b07fae1" => :catalina
    sha256 "df75758d4b4756b23530ec54e2289148652e3f54d6f9a8e45c43f662bc69d7c2" => :mojave
    sha256 "821f8c8df3ada242236f2f231ae72cdcaf23412a5e22458c23df453631129300" => :high_sierra
    sha256 "c1bd2046c7055bc4d321b40336e00ba6d30cabce4bdfd84aea766f4758f4a4d3" => :x86_64_linux
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end

class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.9.1/mlr-5.9.1.tar.gz"
  sha256 "fb531efe5759b99935ce420c8ad763099cf11c2db8d32e8524753f4271454b57"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "775f496bb2d1aaee32a3bb103eb85cfb7b8c4937972b36f7c3960f4a826ca05d" => :big_sur
    sha256 "f723f639b78b03e09657ec505aaac48b7971fbe924b4269f860f1bc97f7db9cc" => :catalina
    sha256 "36c0835f067998aa8458762915d3cfaf8304170fe47433c43f7001a302110e08" => :mojave
    sha256 "e034b65d138c356931f0c29d5808d6d8cbc3468bfb7a0007edd37637f0dd265b" => :high_sierra
    sha256 "a3c9b74132a763ed2b167757853a8db00df69da59204176e496d56ce586b7412" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  def install
    # Profiling build fails with Xcode 11, remove it
    inreplace "c/Makefile.am", /noinst_PROGRAMS=\s*mlrg/, ""
    system "autoreconf", "-fvi"

    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    # Time zone related tests fail. Reported upstream https://github.com/johnkerl/miller/issues/237
    system "make", "check" if !OS.mac? && ENV["CI"]
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end

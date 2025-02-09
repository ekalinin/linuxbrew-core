class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.96.0",
      revision: "9c3cf772426aef125c979c81d93e0dda37ab95b8"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url "https://github.com/influxdata/flux/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "8c638fe223f0211e9a9fe9e5c979b36b53a9fb37d6444250b8cb8d240540b9a5" => :big_sur
    sha256 "bc46820524e04336295652034ea781060993a841b62d902d91b295edb24cca89" => :catalina
    sha256 "fdef740161869f72f77eb79898613501c92909077e6272f693edf50e48d543a2" => :mojave
    sha256 "690020c84188f1bf045a6a11fa27a298669bce681756f3b5b4792145f171c34b" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    on_macos do
      lib.install "libflux/target/x86_64-apple-darwin/release/libflux.dylib"
      lib.install "libflux/target/x86_64-apple-darwin/release/libflux.a"
    end
    on_linux do
      lib.install "libflux/target/x86_64-unknown-linux-gnu/release/libflux.so"
      lib.install "libflux/target/x86_64-unknown-linux-gnu/release/libflux.a"
    end
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end

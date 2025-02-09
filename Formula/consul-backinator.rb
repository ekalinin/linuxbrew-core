class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.5.tar.gz"
  sha256 "e464d597a3a28c6376e0d602c9484a465476db13684585bd52c6b5d81b07019d"
  license "MPL-2.0"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae9c573b6210046ab4974fbb03f3ead33eebe961ffa04719f43f87340e0febe" => :big_sur
    sha256 "576e5b76d9ea50e2e68d6aa48ee434d26654a08f4c17f4dbb720aeafe59abc19" => :catalina
    sha256 "b7504895bfee3e1f3c9318de55a7c60cb256d3d433766f3178fcea7260c04863" => :mojave
    sha256 "f77ec3bd0fa7598d79ca30469140e989ddae59dbb5512d0aa22f0c21190dcd02" => :high_sierra
    sha256 "c52eaf11b850dea9c74b96d94157d25ee1912e52423628105c8b8d9240a2e52a" => :sierra
    sha256 "bb39c88ad9e3e5aa6b12ea08bbd6ec2b31601d0c14f943aaaf10bfcf14cc5b8d" => :el_capitan
    sha256 "9dba886712a0b508e360ec764ef7004a1251bae60a1024c7637ef11c62027904" => :x86_64_linux
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    dir = buildpath/"src/github.com/myENA/consul-backinator"
    dir.install buildpath.children

    cd dir do
      system "glide", "install"
      system "go", "build", "-v", "-ldflags",
             "-X main.appVersion=#{version}", "-o",
             bin/"consul-backinator"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/consul-backinator --version 2>&1")
    assert_equal version.to_s, output.strip
  end
end

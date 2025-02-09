require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.11.0.tgz"
  sha256 "42a49cb112ae91015116b360a3d75da509d459d6f03d3c5b4c38ed20b6436294"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4528a56cd7632fb80f4382c81edcd31feedbca174603df7b38a5c4017335b2fb" => :big_sur
    sha256 "c641a16f691b80643d5d9bf68056953dba80044956b87bef3269f008433bbb0d" => :catalina
    sha256 "64bf5b0274d9fd434c6d8d80489fd13ebebd1e2f1bd7acaed285fc2a4749b36d" => :mojave
    sha256 "0893698205caab0e12f9a75291649de97d2e409e850fec41eac0373d3ea05964" => :high_sierra
    sha256 "b7b19821487b5bef04373f0124b5d22da74681a4b2c23576431cc5d92ded7712" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end

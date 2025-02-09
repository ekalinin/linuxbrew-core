class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.14.0",
      revision: "8ade2f8319af26969d349a40d0777d175e0d10c6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99877b04ef3944e163867c1c59b522ac7707dd1458e8cc550be3662a671436b0" => :big_sur
    sha256 "aa6a8c32407b42927effa946bab30faec2bd3e984321e5c9165f92c5db098980" => :catalina
    sha256 "4b11d3a328eb0e81431c1663e615c85a431e9abaf29bf5bc0dd867801f0db604" => :mojave
    sha256 "4c0591a4c4ea73c19fee0f288d4b64946e573bbace7780cebee2328c88abc0b5" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end

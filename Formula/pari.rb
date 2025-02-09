class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.0.tar.gz"
  sha256 "c811946de9d2c1ed0e97ff08e80d966f9a0b55848b7688406fab229e3948ba93"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/pari[._-]v?(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 "7ace3e8f2f47e1c88afb201ba7ac04d3b8256087a35ef54d87fc8c7b360bbe07" => :big_sur
    sha256 "1394ad170419cc2002f364bdf3ec579823ca259ec4e082f225fcff3d52b1bde9" => :catalina
    sha256 "ab722c114214113c867f878cf7016d67f2d0dea2cc6e1526e8924fc5b5fb21cd" => :mojave
    sha256 "c0e5508356c5cc200b5085c4e46a3bb233cf02e6146ebe4eeaf1abc5b0af071b" => :high_sierra
    sha256 "9e4766ede2255db13e01e1250123494191fb4e9776656c8973b0ac892f0099f7" => :x86_64_linux
  end

  depends_on "gmp"
  depends_on "readline"
  depends_on "texlive" => :build unless OS.mac?

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps"
    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    os = OS.mac? ? "mac" : "linux"
    inreplace lib/"pari/pari.cfg", HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/", "/usr/bin/"
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew cask install xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end

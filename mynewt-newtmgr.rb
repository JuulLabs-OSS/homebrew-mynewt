class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_1_0_tag.tar.gz"
  version "1.1.0"
  sha256 "5a1e75a5201869ee35ade2eb61eadd6a5e0ad76308e30e0268381b2745326f19"

  head "https://github.com/apache/mynewt-newtmgr.git"

#  bottle do
#    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.1.0"
#    root_url "https://github.com/cwanda/homebrew-testmynewt/raw/master/"
#     cellar :any_skip_relocation
#     sha256 "ab43fa70023eba77122b52ccc8b9ddc08bbc2d154667b1c298182e5538b53f95" => :sierra
#  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newtmgr").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

# We are not able to vendor these packages due to a "go get" bug in 
# vendoring packages with platform dependent code. So we have to get
# these packages for the buid.
  
    cd gopath/"src" do
       system "go", "get", "github.com/currantlabs/ble"
       system "go", "get", "github.com/raff/goble"
       system "go", "get", "github.com/mgutz/logxi/v1"
    end

    cd gopath/"src/mynewt.apache.org/newtmgr/newtmgr" do
      system "go", "install"
      bin.install gopath/"bin/newtmgr"
    end
  end

  test do
    # Check for Newtmgr in first word of output.
    assert_match "Newtmgr", shell_output("#{bin}/newtmgr").split.first
  end
end

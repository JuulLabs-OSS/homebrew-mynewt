class MynewtNewtmgrAT12 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_2_0_tag.tar.gz"
  version "1.2.0"
  sha256 "435c2e66a872bef7b13fbf3cc48add8aba7cb7482849eac234e1499b62c95e6d"

  keg_only :versioned_formula

  bottle do
     root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.2.0"
     cellar :any_skip_relocation
    sha256 "588884187b39ea39f7e1a900cc89e8f8a029bd20eb6712bc796ca0834145249a" => :sierra
  end

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

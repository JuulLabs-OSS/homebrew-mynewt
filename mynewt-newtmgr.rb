class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_1_0_tag.tar.gz"
  version "1.1.0"
  sha256 "8077d285aaecf61d4d11d45c56640197ad1ff8f9fa93485893c65ee57818ecde"

  head "https://github.com/apache/mynewt-newtmgr.git"

  bottle do
#    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.1.0"
#    root_url "https://github.com/cwanda/homebrew-testmynewt/raw/master/"
     cellar :any_skip_relocation
     sha256 "1c03414d3f5c821b6040160a6a6c5036cd61f7579075736e57bb305d5fd779f0" => :yosemite
     sha256 "cefe59d785fc43523e7341c2231690703f885e8510c9ec8f3bee30e6c0943419" => :el_capitan
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

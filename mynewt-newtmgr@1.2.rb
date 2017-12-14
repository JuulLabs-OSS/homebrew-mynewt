class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_2_0_tag.tar.gz"
  version "1.2.0"
  sha256 "435c2e66a872bef7b13fbf3cc48add8aba7cb7482849eac234e1499b62c95e6d"

  head "https://github.com/apache/mynewt-newtmgr.git"

  bottle do
     root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.2.0"
     cellar :any_skip_relocation
     sha256 "a03b89de0b5790b3b7831cf610da45568f81a59d1bab8c0e8af08918d6aeac64" => :sierra
     sha256 "8b0018aadbf0ba5c5ce91cbb006fca9ead2999db83ae599f07f9d7935a0db9c1" => :el_capitan
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

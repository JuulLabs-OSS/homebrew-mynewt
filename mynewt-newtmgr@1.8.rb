class MynewtNewtmgrAT18 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_8_0_tag.tar.gz"
  version "1.8.0"
  sha256 "9914e614c3d7fcf64ce03fff7918f29711a7c48e35f6057ea0761e27b841339c"

  keg_only :versioned_formula

  bottle do
     root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.7.0"
     cellar :any_skip_relocation
    sha256 "d7abe378aebcca72b7ebdca343b2eb401e5b721762d25b670cf8926aeb543bbf" => :big_sur
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newtmgr").install contents

    cd gopath/"src/mynewt.apache.org/newtmgr/newtmgr" do
      system "go", "build"
      bin.install "newtmgr"
    end
  end

  test do
    # Check for Newtmgr in first word of output.
    assert_match "Newtmgr", shell_output("#{bin}/newtmgr").split.first
  end
end

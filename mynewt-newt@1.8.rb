class MynewtNewtAT18 < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_8_0_tag.tar.gz"
  version "1.8.0"
  sha256 "9914e614c3d7fcf64ce03fff7918f29711a7c48e35f6057ea0761e27b841339c"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.7.0"
    cellar :any_skip_relocation
    sha256 "f2516115cec9395732f7def32510685a71f5de4348b5fd5618e9788499dc1053" => :big_sur
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newt").install contents

    cd gopath/"src/mynewt.apache.org/newt" do
      system "./build.sh"
      bin.install "newt/newt"
    end
  end

  test do
    # Compare newt version string
    assert_equal "1.8.0", shell_output("#{bin}/newt version").split.last
  end
end

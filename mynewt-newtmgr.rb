class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_7_0_tag.tar.gz"
  version "1.7.0"
  sha256 "7aaa8c1c6899a9f39957b51e69d02d5c202a58fa104efcdc5bae75d4691b8c2f"

  head "https://github.com/apache/mynewt-newtmgr.git"

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

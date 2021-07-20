# typed: false
# frozen_string_literal: true

class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_9_0_tag.tar.gz"
  version "1.9.0"
  sha256 "50362008be68f96a01d3ee89b9e3cb45ec624947cada62f4de74e336104fa0dd"

  head "https://github.com/apache/mynewt-newtmgr.git"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.9.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f9253bb2260916708b01744590db0302da1c14b770c1709afe547773fbe1dfe7"
  end

  depends_on "go" => :build
  depends_on arch: :x86_64

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

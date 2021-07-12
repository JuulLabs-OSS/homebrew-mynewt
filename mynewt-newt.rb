# typed: false
# frozen_string_literal: true

class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_8_0_tag.tar.gz"
  version "1.8.0"
  sha256 "9914e614c3d7fcf64ce03fff7918f29711a7c48e35f6057ea0761e27b841339c"

  head "https://github.com/apache/mynewt-newt.git"

  depends_on "go" => :build
  depends_on arch: :x86_64

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
    assert_equal "1.7.0", shell_output("#{bin}/newt version").split.last
  end
end

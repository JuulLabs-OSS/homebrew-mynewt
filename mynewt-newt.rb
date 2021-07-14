# typed: false
# frozen_string_literal: true

class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_9_0_tag.tar.gz"
  version "1.9.0"
  sha256 "c827986e27167e308f95ce226b04f801dc8f2d862bf7437358e715c0be8f1080"

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
    assert_equal "1.9.0", shell_output("#{bin}/newt version").split.last
  end
end

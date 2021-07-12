# typed: false
# frozen_string_literal: true

class MynewtNewtAT12 < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_2_0_tag.tar.gz"
  version "1.2.0"
  sha256 "41e1b7ee526d1861e7b1e880848d090484960a6bafb31bb62d38d25212146736"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.2.0"
    sha256 cellar: :any_skip_relocation, sierra: "14c58895c9805aa1df17638e483adb8a37fdb6911f96c7e80535fed2fa82ac94"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on arch: :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newt").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/mynewt.apache.org/newt/newt" do
      system "go", "install"
      bin.install gopath/"bin/newt"
    end
  end

  test do
    # Compare newt version string
    assert_equal "1.2.0", shell_output("#{bin}/newt version").split.last
  end
end

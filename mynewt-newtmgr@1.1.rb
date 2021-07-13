# typed: false
# frozen_string_literal: true

class MynewtNewtmgrAT11 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol (1.1)"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_1_0_tag.tar.gz"
  version "1.1.0"
  sha256 "8077d285aaecf61d4d11d45c56640197ad1ff8f9fa93485893c65ee57818ecde"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.1.0"
    sha256 cellar: :any_skip_relocation, sierra: "5f7cbe8e58c04fdba5b2a7ee142429ebf57802e0c64659585759f231c808c31c"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on arch: :x86_64

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

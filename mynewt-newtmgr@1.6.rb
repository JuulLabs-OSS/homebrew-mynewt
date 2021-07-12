# typed: false
# frozen_string_literal: true

class MynewtNewtmgrAT16 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_6_0_tag.tar.gz"
  version "1.6.0"
  sha256 "b85e61ae8a163864d6a25cc9836f52b26c77c51262e0e56c5ea4856577c8805e"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.6.0"
    sha256 cellar: :any_skip_relocation, high_sierra: "653580c0726b8f4740fcf71d775efe0758f1eff9fd7c0a6273cede487aad863d"
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

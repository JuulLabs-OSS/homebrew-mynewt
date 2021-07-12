# typed: false
# frozen_string_literal: true

class MynewtNewtmgrAT10 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_0_0_tag.tar.gz"
  version "1.0.0"
  sha256 "6c39967881357b228c54683c1eaffb47662edbafee7e07c1a27351857a54b5dd"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.0.0"
    sha256 cellar: :any_skip_relocation, sierra:     "63b1be15469ddbacb31ccc10eb0f8314f8248b3c2d94b6e31f1259c361ec2128"
    sha256 cellar: :any_skip_relocation, el_capitan: "e8b84cca0cd5a92dff33e343ca9de87bdfed51353ccfbeadb8aea6c63704c114"
    sha256 cellar: :any_skip_relocation, yosemite:   "f824ccea8eae3ac293f450d5e0d4d8a4b1e928394f4d979ab740fe67b8c97ec0"
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

    cd gopath/"src/mynewt.apache.org/newt/newtmgr" do
      system "go", "install"
      bin.install gopath/"bin/newtmgr"
    end
  end

  test do
    # Check for Newtmgr in first word of output.
    assert_match "Newtmgr", shell_output("#{bin}/newtmgr").split.first
  end
end

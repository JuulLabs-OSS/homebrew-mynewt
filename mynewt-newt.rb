class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_1_0_tag.tar.gz"
  version "1.1.0"
  sha256 "66a90b54034255e073206cc27d9d1a63b76d6dd56a847e4f224a50e3de942aad"

  head "https://github.com/apache/mynewt-newt.git"

  bottle do
#     root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.1.0"
    root_url "https://github.com/cwanda/homebrew-testmynewt/raw/master"
    cellar :any_skip_relocation
    sha256 "68221671cc744d90ae06235e49a8638dd75a36677d27baea7f16ef1482a4127e" => :sierra
    sha256 "3092023e660ac252c5ad07166f9ea6ebb31f665c4c1d496698b7982de9d9dc08" => :yosemite
    sha256 "83e119596ffa17c1f828686245428082e0cb4605680c93ea01155994c82595ce" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

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
    assert_equal "1.1.0", shell_output("#{bin}/newt version").split.last
  end
end

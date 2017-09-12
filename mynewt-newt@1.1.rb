class MynewtNewtAT11 < Formula
  desc "Package, build and installation system for Mynewt OS applications (1.1)"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_1_0_tag.tar.gz"
  version "1.1.0"
  sha256 "66a90b54034255e073206cc27d9d1a63b76d6dd56a847e4f224a50e3de942aad"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.1.0"
    cellar :any_skip_relocation
    sha256 "c25c240b87978ce246ac1b094dd519a6b6a30e0d09a580d8357b45821eb64923" => :sierra
  end

  keg_only :versioned_formula

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

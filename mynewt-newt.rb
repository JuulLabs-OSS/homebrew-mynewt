class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_2_0_tag.tar.gz"
  version "1.2.0"
  sha256 "41e1b7ee526d1861e7b1e880848d090484960a6bafb31bb62d38d25212146736"

  head "https://github.com/apache/mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.2.0"
    cellar :any_skip_relocation
    sha256 "e3c51a0b13d07802e89993fef48a7ae8c519cecf1468815967e3c6993105859c" => :sierra
    sha256 "0a35aad27486a8dda70791798644d5c8818fe69db772920ff14a674318468801" => :el_capitan
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
    assert_equal "1.2.0", shell_output("#{bin}/newt version").split.last
  end
end

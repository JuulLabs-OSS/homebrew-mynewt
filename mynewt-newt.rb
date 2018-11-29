class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_5_0_tag.tar.gz"
  version "1.5.0"
  sha256 "c552a0b0eb8a81168abb868856e0ff323d97e433fdb87b7d57cb70de21c5ae1b"

  head "https://github.com/apache/mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.5.0"
    cellar :any_skip_relocation
    sha256 "a0a1dffd4fb541343f265a050c4ccb236cc3cce073ef5e4d06b3a69ad4a9d4d1" => :sierra
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
    assert_equal "1.5.0", shell_output("#{bin}/newt version").split.last
  end
end

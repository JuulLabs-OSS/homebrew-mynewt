class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/incubator-mynewt-newt/archive/mynewt_1_0_0_tag.tar.gz"
  version "1.0.0"
  sha256 "699239691b6fe2e5bb0bb24727cd56740400e6074a369756b890ea7ec290d1bd"

  head "https://github.com/apache/incubator-mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.0.0"
    cellar :any_skip_relocation
    sha256 "bbcd73426e3807261102d59687cdf77e369a6d172a61394351c1ffc4ffd27396" => :mavericks_or_later
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
    assert_equal "1.0.0", shell_output("#{bin}/newt version").split.last
  end
end

class MynewtNewtAT14 < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_4_1_tag.tar.gz"
  version "1.4.1"
  sha256 "496a5d9fb6e8fb25354cbc7f2aa3507e28e34c980e790ef6c0c4f1cf6d993ec9"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.4.1"
    cellar :any_skip_relocation
    sha256 "b5c535039ac48e2ebeb27d74241ea4a3c3b0f8ce08a2bd1043b72acc2ed03408" => :sierra
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
    assert_equal "1.4.1", shell_output("#{bin}/newt version").split.last
  end
end

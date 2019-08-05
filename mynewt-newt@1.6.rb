class MynewtNewtAT16 < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_6_0_tag.tar.gz"
  version "1.6.0"
  sha256 "5245fba3d2befc44cd71733dc5c9ae07681cc47d8f79152f439c021d446b7122"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.6.0"
    cellar :any_skip_relocation
    sha256 "8dea2947d0cfd60729f5faf17db867ceeae639541849db3e00f380af1a140f3a" => :high_sierra
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
    assert_equal "1.6.0", shell_output("#{bin}/newt version").split.last
  end
end

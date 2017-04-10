class MynewtNewtmgr < Formula
  desc "Tool to communicate with remote Mynewt OS applications via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/incubator-mynewt-newt/archive/mynewt_1_0_0_tag.tar.gz"
  version "1.0.0"
  sha256 "699239691b6fe2e5bb0bb24727cd56740400e6074a369756b890ea7ec290d1bd"

  head "https://github.com/apache/incubator-mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/releases/download/mynewt-newt_1_0_0/"
    cellar :any_skip_relocation
    sha256 "a4a8878e5062756d431eaacc383f38a74fb1e28a74198b4fc1ca0c7620936b2e" => :mavericks_or_later
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

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

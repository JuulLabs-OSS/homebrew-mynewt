class MynewtNewtmgrAT10 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_0_0_tag.tar.gz"
  version "1.0.0"
  sha256 "6c39967881357b228c54683c1eaffb47662edbafee7e07c1a27351857a54b5dd"

#  head "https://github.com/apache/incubator-mynewt-newt.git"

#  bottle do
#    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.0.0"
#    cellar :any_skip_relocation
#    sha256 "a4a8878e5062756d431eaacc383f38a74fb1e28a74198b4fc1ca0c7620936b2e" => :mavericks_or_later
#  end

keg_only :versioned_formula

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

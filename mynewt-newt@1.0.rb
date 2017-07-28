class MynewtNewtAT10 < Formula
  desc "Package, build and installation system for Mynewt OS applications (1.0)"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_0_0_tag.tar.gz"
  version "1.0.0"
  sha256 "6c39967881357b228c54683c1eaffb47662edbafee7e07c1a27351857a54b5dd"

  bottle do
#    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.0.0"
    root_url "https://github.com/cwanda/homebrew-testmynewt/raw/master"
    cellar :any_skip_relocation
    sha256 "1ecb25e903ae3dcb35461455babaccf7c061b95a1a95f0bc6b16d646052c4546" => :yosemite
    sha256 "6af9fd1e94593b73ee9fcd6511fcf648005db413a3a6cc76709a8b8c219c5a1f" => :el_capitan
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
    assert_equal "1.0.0", shell_output("#{bin}/newt version").split.last
  end
end

class MynewtNewtAT10 < Formula
  desc "Package, build and installation system for Mynewt OS applications (1.0)"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_0_0_tag.tar.gz"
  version "1.0.0"
  sha256 "6c39967881357b228c54683c1eaffb47662edbafee7e07c1a27351857a54b5dd"

#  bottle do
#    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.0.0"
#    root_url "https://github.com/cwanda/homebrew-testmynewt/raw/master"
#    cellar :any_skip_relocation
#    sha256 "bbcd73426e3807261102d59687cdf77e369a6d172a61394351c1ffc4ffd27396" => :mavericks_or_later
#     sha256 "2906f1881845597bef90d02d7581a7b518af0c75b58ebf88676b30ad6995ba28" => :sierra
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
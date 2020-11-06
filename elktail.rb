require "language/go"

class Elktail < Formula
  desc "Elktail is command line utility for tailing, querying and searching logstash / elasticsearch logs"
  homepage "https://github.com/knes1/elktail"
  url "https://github.com/wooyey/elktail/archive/v5.1.8.tar.gz"
  sha256 "7596ed589823e67ed1ae3761196e449b7f458a148a764bab1523b16cb2072a12"

  depends_on "go" => :build

#   go_resource "github.com/codegangsta/cli" do
#     url "https://github.com/codegangsta/cli.git",
#       :revision => "0302d3914d2a6ad61404584cdae6e6dbc9c03599"
#   end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "346896d57731cb5670b36c6178fc5519f3225980"
  end

  go_resource "gopkg.in/olivere/elastic.v5" do
    url "https://github.com/olivere/elastic.git",
      :revision => "423089d8ab13afc03106c217ba1a43d8b8b178c8"
  end
  
  go_resource "github.com/mailru/easyjson" do 
    url "https://github.com/mailru/easyjson.git",
      :revision => "fca00f44f19dad8763e34502718a2bb90d98bdc1"
  end
  
  go_resource "github.com/josharian/intern" do
    url "https://github.com/josharian/intern.git",
      :revision => "a140101e2404c737ca154f12ac2a9d1cc161aee6"
  end
  
  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
      :revision => "614d223910a179a466c1767a985424175c39b465"
  end
  
  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
      :revision => "ec731febcc3bc1812f23bddd81e6f0bf8120472e"
  end
  
  def install
    puts buildpath
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/knes1/elktail").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/knes1/elktail" do
      system "go install"
      #puts system("ls -al")
      #puts system("pwd")
      #bin.install elktail"
    end
    bin.install gopath/"bin/elktail"
  end

  test do
    assert_match(/elktail version/, shell_output("#{bin}/elktail -v"))
  end
end

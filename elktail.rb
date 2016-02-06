require "language/go"

class Elktail < Formula
  desc "Elktail is command line utility for tailing, querying and searching logstash / elasticsearch logs"
  homepage "https://github.com/knes1/elktail"
  url "https://github.com/knes1/elktail/archive/v0.1.1.tar.gz"
  sha256 "1f1667e6cfb2bef19a80c843ffffa226edc451cfa294ffeb54d27a3a9fbc5643"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "0302d3914d2a6ad61404584cdae6e6dbc9c03599"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "346896d57731cb5670b36c6178fc5519f3225980"
  end

  go_resource "gopkg.in/olivere/elastic.v2" do
    url "https://gopkg.in/olivere/elastic.v2.git",
      :revision => "9f744c4a57dd7c636101aef9678f51dddc83b068"
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

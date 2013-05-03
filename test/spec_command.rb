require "ghwikitools"
require "temppath"
require "fileutils"

include GHWikiTools
Command.test_mode = true

describe "GHWikiTools::Command" do
  before do
    Temppath.update_tempdir
    FileUtils.cp_r(File.join(File.dirname(__FILE__), "ghwiki"), Temppath.dir)
    GHWikiTools.dir = Temppath.dir + "ghwiki"
  end

  it "should update" do
    Command.new.invoke("update")
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.should.include_snippet "Header"
      page.should.include_snippet "Footer"
    end
  end

  it "should update in specified directory" do
    Temppath.update_tempdir
    FileUtils.cp_r(File.join(File.dirname(__FILE__), "ghwiki"), Temppath.dir)
    Command.new.invoke("update", nil, {directory: (Temppath.dir + "ghwiki").to_s})
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.should.include_snippet "Header"
      page.should.include_snippet "Footer"
    end
  end

  it "should delete snippet" do
    Command.new.invoke("delete_snippet", ["Footer"])
    Page.by_filename("Page-markdown-1.md").tap do |page|
      page.should.include_snippet "Header"
      page.should.not.include_snippet "Footer"
    end
  end

  it "should delete snippet in specified directory" do
    Temppath.update_tempdir
    FileUtils.cp_r(File.join(File.dirname(__FILE__), "ghwiki"), Temppath.dir)
    Command.new.invoke("delete_snippet", ["Footer"], {directory: (Temppath.dir + "ghwiki").to_s})
    Page.by_filename("Page-markdown-1.md").tap do |page|
      page.should.include_snippet "Header"
      page.should.not.include_snippet "Footer"
    end
  end

  it "should get help message with the option '--help'" do
    should.not.raise do
      command = Command.new([], {help: true, quiet: true}, {})
      command.invoke(:update)
    end
  end
end

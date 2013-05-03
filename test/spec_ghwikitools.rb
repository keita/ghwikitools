require "ghwikitools"

GHWikiTools.dir = File.join(File.dirname(__FILE__), "ghwiki")

describe "GHWikiTools" do
  it "should get GitHub wiki directory" do
    GHWikiTools.dir.should.kind_of Pathname
    GHWikiTools.dir.should == Pathname.new(File.join(File.dirname(__FILE__), "ghwiki"))
  end
end

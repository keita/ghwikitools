# -*- coding: utf-8 -*-
require "ghwikitools"

GHWikiTools.dir = File.join(File.dirname(__FILE__), "ghwiki")

include GHWikiTools

describe "GHWikiTools::Snippet" do
  it "should get all snippets" do
    Snippet.all.tap do |snippets|
      snippets.size.should == 2
      names = snippets.map{|snippet| snippet.name}.uniq
      names.should.include "Header"
      names.should.include "Footer"
    end
  end

  it "should render the snippet content with page informations" do
    page = Page.by_filename("Page-markdown-1.md")
    snippet = Snippet.by_filename("_Header.md")
    snippet.render(page).should ==
      "Languages: [[English|Page-markdown-1]] | [[日本語|Page-markdown-1.ja]]"
  end
end

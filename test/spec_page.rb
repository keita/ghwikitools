# -*- coding: utf-8 -*-
require "ghwikitools"

GHWikiTools.dir = File.join(File.dirname(__FILE__), "ghwiki")

include GHWikiTools

describe "GHWikiTools::Page" do
  it "should get all pages" do
    Page.all.tap do |pages|
      pages.size.should == 7
      wikinames = pages.map{|page| page.wikiname}.uniq
      wikinames.should.include "Page-markdown-1"
      wikinames.should.include "Page-markdown-2"
      wikinames.should.include "Page-markdown-3"
      wikinames.should.not.include "not-page"
    end
  end

  it "should get a page by the filename" do
    page = Page.by_filename("Page-markdown-1.md")
    page.should.kind_of Page
    page.wikiname.should == "Page-markdown-1"
    page.lang.should.nil
    page.ext.should == :md
    page.should.valid
  end

  it "should get a Japanese page by the filename" do
    page = Page.by_filename("Page-markdown-1.ja.md")
    page.should.kind_of Page
    page.wikiname.should == "Page-markdown-1"
    page.lang.should == :ja
    page.ext.should == :md
    page.should.valid
  end

  it "should get language and extension" do
    Page.by_filename("Page-markdown-4.abc.ja.md").tap do |page|
      page.wikiname.should == "Page-markdown-4.abc"
      page.lang.should == :ja
      page.ext.should == :md
    end
  end

  it "should get wikiname of the language" do
    page = Page.by_filename("Page-markdown-1.md")
    page.wikiname(:ja).should == "Page-markdown-1.ja"
  end

  it "should find snippets" do
    page = Page.by_filename("Page-markdown-snippets.md")
    snippets = page.find_snippets
    snippets.size.should == 5
  end

  it 'should get the page content with inserting the header' do
    page = Page.by_filename("Page-markdown-1.md")
    page.render_snippets.should == <<TXT
<!-- >>> Header -->

Languages: [[English|Page-markdown-1]] | [[日本語|Page-markdown-1.ja]]

<!-- <<< Header -->

This is Page1.
TXT
  end

  it 'should get the page content with updating the header' do
    page = Page.by_filename("Page-markdown-2.md")
    page.render_snippets.should == <<TXT
<!-- >>> Header -->

Languages: [[English|Page-markdown-2]] | [[日本語|Page-markdown-2.ja]]

<!-- <<< Header -->

This is Page2.
TXT
  end
end

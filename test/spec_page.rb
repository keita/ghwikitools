# -*- coding: utf-8 -*-
require "ghwikitools"
require "temppath"
require "fileutils"

include GHWikiTools

describe "GHWikiTools::Page" do
  before do
    Temppath.update_tempdir
    FileUtils.cp_r(File.join(File.dirname(__FILE__), "ghwiki"), Temppath.dir)
    GHWikiTools.dir = Temppath.dir + "ghwiki"
  end

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

  it "should include snippets" do
    Page.by_filename("Page-markdown-snippets.md").tap do |page|
      page.should.include_snippet "Header"
      page.should.include_snippet "Snippet1"
      page.should.include_snippet "Snippet2"
      page.should.include_snippet "Snippet3"
      page.should.include_snippet "Footer"
    end
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

<!-- >>> Footer -->

This is a footer.

<!-- <<< Footer -->
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

  it 'should insert header' do
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.should.not.include_snippet "Header"
      page.insert_header.should == true
      page.should.include_snippet "Header"
    end
  end

  it 'should not insert header when header snippet file not found' do
    Snippet.by_filename("_Header.md").path.delete
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.should.not.include_snippet "Header"
      page.insert_header.should == false
      page.should.not.include_snippet "Header"
    end
  end

  it 'should not insert header when header snippet exists already' do
    Page.by_filename("Page-markdown-2.md").tap do |page|
      page.should.include_snippet "Header"
      page.insert_header.should == false
      page.should.include_snippet "Header"
    end
  end

  it 'should insert footer' do
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.should.not.include_snippet "Footer"
      page.insert_footer.should == true
      page.should.include_snippet "Footer"
    end
  end

  it 'should not insert footer when footer snippet file not found' do
    Snippet.by_filename("_Footer.md").path.delete
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.should.not.include_snippet "Footer"
      page.insert_footer.should == false
      page.should.not.include_snippet "Footer"
    end
  end

  it 'should not insert footer when footer snippet exists already' do
    Page.by_filename("Page-markdown-1.md").tap do |page|
      page.should.include_snippet "Footer"
      page.insert_footer.should == false
      page.should.include_snippet "Footer"
    end
  end

  it 'should update snippets' do
    Page.by_filename("Page-markdown-2.md").tap do |page|
      content = page.render_snippets
      page.update_snippets.should == true
      page.path.read.should == content
    end
  end

  it 'should not update snippets' do
    Page.by_filename("Page-markdown-3.md").tap do |page|
      page.update_snippets.should == false
    end
  end

  it 'should delete snippet' do
    Page.by_filename("Page-markdown-2.md").tap do |page|
      page.should.include_snippet "Header"
      page.delete_snippet("Header").should == true
      page.should.not.include_snippet "Header"
    end
  end

  it 'should delete snippet' do
    Page.by_filename("Page-markdown-2.md").tap do |page|
      page.should.not.include_snippet "Footer"
      page.delete_snippet("Footer").should == false
    end
  end
end

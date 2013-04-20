require "pathname"
require "erb"
require 'optparse'

require "ghwikitools/version"
require "ghwikitools/page"
require "ghwikitools/snippet"
require "ghwikitools/command"

# GHWikiTools is a name space for ghwikitools library.
module GHWikiTools
  # available extensions in GitHub wiki
  EXTENSIONS = [
    :asciidoc , # ASCIIDoc
    :creole   , # Creole
    :md       , # Markdown
    :org      , # Org Mode
    :pod      , # Pod
    :rdoc     , # RDoc
    :rest     , # ReStructuredText
    :textile  , # Textile
    :mediawiki  # MediaWiki
  ]

  class << self
    # @return [Pathname]
    #   path of GitHub wiki directory
    attr_reader :dir

    # Set GitHub wiki cloned directory.
    #
    # @param path [String,Pathname]
    #   path of GitHub wiki cloned directory
    # @return [void]
    def dir=(path)
      @dir = Pathname.new(path)
    end
  end

  # default path
  @dir = Pathname.new(".")
end

module GHWikiTools
  # Snippet is a small block text of wiki page.
  class Snippet < Page
    class << self
      # Return snippetss directory.
      def dir
        GHWikiTools.dir + "snippet"
      end
    end

    # Render the snippet with the page.
    #
    # @param page [Page]
    #   the page that the snippet embeds in it
    def render(page)
      ERB.new(@path.read, nil, 2).result(SnippetContext.create(page))
    end
  end

  # SnippetContext provides snippet rendering informations.
  class SnippetContext
    class << self
      # Return the context as binding object.
      #
      # @param page [Page]
      #   the page that the snippet embeds in it
      # @return [Binding]
      #   snippet context as binding object
      def create(page)
        new(page).binding
      end
    end

    # @param page [Page]
    #   the page that the snippet embeds in it
    def initialize(page)
      @page = page
    end

    # Return the environment binding object.
    #
    # @return [Binding]
    #   the environment binding object
    def binding
      Kernel.binding
    end
  end
end

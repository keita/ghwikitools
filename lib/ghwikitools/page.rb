module GHWikiTools
  # Page is a class for wiki pages.
  class Page
    class << self
      # Return pages directory.
      def dir
        GHWikiTools.dir
      end

      # Return all pages in the wiki.
      #
      # @return [Array<Page>]
      #   all pages
      def all
        Pathname.new(dir).entries.select{|e| (dir + e).file?}.map do |entry|
          by_filename(entry.to_s)
        end.select {|page| page.valid?}
      end

      # Create a page by the filename.
      #
      # @param filename [String]
      #   the filename
      # @return [Page]
      #   the page
      def by_filename(filename)
        raise ArgumentError.new(filename) unless filename.include?(".")
        path, basename, lang, ext = parse_filename(filename)
        new(path, basename, lang, ext)
      end

      private

      # Parse the filename.
      #
      # @param filename [String]
      #   the filename
      # @return [Array]
      #   basename(String), language name(Symbol), and extensiton(Symbol)
      def parse_filename(filename)
        filename.split(".").tap do |array|
          # extension
          ext = array[-1].to_sym

          # language
          lang = array[-2].to_sym if array.size >= 3 and ISO_639.find(array[-2])

          # basename
          basename = (lang ? array[0..-3] : array[0..-2]).join(".").tap do |name|
            break (name[0] == "_" and self == Snippet) ? name[1..-1] : name
          end

          # path
          path = dir + filename

          return path, basename, lang, ext
        end
      end
    end

    # @param [Pathname]
    #   path of the page
    attr_reader :path

    # @param [String]
    #   name of the page
    attr_reader :name

    # @param [String]
    #   language name of the page
    attr_reader :lang

    # @param [String]
    #   extension of the page
    attr_reader :ext

    # @param path [Pathname]
    #   page file path
    # @param name [String]
    #   name
    # @param lang [Symbol]
    #   language name
    # @param ext [Symbol]
    #   extension name
    def initialize(path, name, lang, ext)
      @path = path
      @name = name
      @lang = lang
      @ext = ext
    end

    # Return true if the page is valid in the meaning of this tools.
    #
    # @return [Boolean]
    #   true if the page is valid
    def valid?
      return false unless EXTENSIONS.include?(@ext) and @path.file? and @path.exist?
      return true
    end

    # Return the wikiname of the page with lang
    def wikiname(lang=nil)
      lang ? "%s.%s" % [@name, lang] : @name
    end

    # Insert a header snippet metadata.
    #
    # @return [Boolean]
    #   true if header metadata was inserted
    def insert_header
      insert_common_snippet("Header", :top)
    end

    # Insert a footer snippet metadata.
    #
    # @return [Boolean]
    #   true if footer metadata was inserted
    def insert_footer
      insert_common_snippet("Footer", :bottom)
    end

    # Update sinppets content in the page. Return true if the page is changed.
    #
    # @return [Boolean]
    #   true if the page is changed
    def update_snippets
      if content = render_snippets
        unless content == @path.read
          @path.open("w+") {|f| f.write(content)}
          return true
        end
      end
      return false
    end

    # Delete the snippet metadata from the page. Return true if the page is changed.
    #
    # @param name [String]
    #   snippet name
    # @return [Boolean]
    #   true if the page is changed
    def delete_snippet(name)
      if find_snippet_metadata.include?(name)
        content = @path.read
        new_content = content.gsub(snippet_regexp(name), "")
        unless content == new_content
          @path.open("w+") {|f| f.write(new_content)}
          return true
        end
      end
      return false
    end

    # Return the result of rendering snippets.
    #
    # @return [String]
    #   result of rendering snippets
    def render_snippets
      find_snippets.inject(@path.read) do |content, snippet|
        if snippet.valid?
          content.gsub(snippet_regexp(snippet.name)) do
            "%s\n\n%s\n\n%s" % [$1, snippet.render(self), $3]
          end
        else
          content
        end
      end
    end

    # Return snippets in the page.
    #
    # @return [Array<Snippet>]
    #   snippets in the page
    def find_snippets
      find_snippet_metadata.map do |name|
        Snippet.by_filename("_%s.%s" % [name, @ext])
      end
    end

    # Return true if the page includes snippet metadata that have the name.
    #
    # @param [String]
    #   snippet name
    # @return [Boolean]
    #   true if the page includes snippet metadata that have the name
    def include_snippet?(name)
      find_snippet_metadata.include?(name)
    end

    private

    # Insert common snippet.
    #
    # @param name [String]
    #   snippet name
    # @param pos [Symbol]
    #   :top or :bottom
    # @return [Boolean]
    #   true if the snippet metadata was inserted.
    def insert_common_snippet(name, pos)
      return false if @name[0] == "_"
      return false unless Snippet.by_filename("_%s.md" % name).path.exist?
      unless find_snippet_metadata.include?(name)
        metadata = "<!-- >>> %s -->\n\n<!-- <<< %s -->" % [name, name]
        case pos
        when :top
          content = metadata + "\n\n" + @path.read
        when :bottom
          content = @path.read + "\n\n" + metadata
        end
        @path.open("w+") {|f| f.write(content)}
        return true
      end
      return false
    end

    # Return a regexp of the named snippet.
    #
    # @param name [String]
    #   snippet's name
    # @return [Regexp]
    #   regexp that matches snippet metadata
    def snippet_regexp(name)
      /(<!--\s*>>>\s*#{name}\s*-->)(.*?)(<!--\s*<<<\s*#{name}\s*-->)/m
    end

    # Return snippets in the page.
    #
    # @return [Array<Snippet>]
    #   snippets in the page
    def find_snippet_metadata
      @path.read.scan(/<!--\s*>>>\s*(.+?)\s*-->/).flatten.uniq
    end
  end
end

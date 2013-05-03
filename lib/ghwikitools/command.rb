module GHWikiTools
  # Command is a class for making sub commands of ghwikitools.
  class Command < Thor
    class << self
      attr_accessor :test_mode
    end

    no_commands do
      forward :class, :test_mode
    end

    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'show help message'
    class_option :directory, :type => :string, :aliases => '-d', :desc => "repository directory path", :banner => "DIR"

    desc "delete_snippet NAME", "Delete snippet metadata"
    def delete_snippet(name)
      if options[:directory]
        puts "repositoy: %s" % options[:directory]
        GHWikiTools.dir = options[:directory]
      end
      GHWikiTools::Page.all.each do |page|
        if page.delete_snippet(name)
          puts 'deleted snippet "%s" in the page %s' % [name, page.name]
        end
      end
    end

    desc "update", "Update header, footer, and other snippets"
    def update
      if options[:directory]
        puts "repositoy: %s" % options[:directory]
        GHWikiTools.dir = options[:directory]
      end
      GHWikiTools::Page.all.each do |page|
        if page.insert_header
          puts 'insert "Header" snippet metadata in the page "%s"' % page.wikiname
        end
        if page.insert_footer
          puts 'insert "Footer" snippet metadata in the page "%s"' % page.wikiname
        end
        if page.update_snippets
          puts 'update snippets in the page "%s"' % page.wikiname
        end
      end
    end

    no_commands do
      define_method(:invoke_command) do |command, *args|
        if options[:help]
          Command.task_help(shell, command.name)
        else
          super(command, *args)
        end
      end
    end

    private

    def puts(*args)
      Kernel.puts(*args) unless test_mode
    end
  end
end

module GHWikiTools
  # Command is a class for making sub commands of ghwikitools.
  class Command
    @table = Hash.new {|hash, key| abort("unknown command %s" % key)}

    @toplevel_options = OptionParser.new.tap do |opt|
      opt.on("--help") do
        @table[:list].new([]).run
        exit
      end
    end

    class << self
      # @api private
      attr_reader :table

      # @return [String]
      #   description of the command
      attr_reader :description

      # Declare the command name.
      #
      # @param name [Symbol]
      #   command name
      # @return [void]
      def command(name)
        Command.table[name] = self
      end

      # Describe the aim of the command.
      #
      # @param msg [String]
      #   message
      # @return [void]
      def describe(msg)
        @description = msg
      end

      # Get 
      def get(argv)
        @toplevel_options.order!(argv).tap do |_argv|
          name, _argv = _argv
          return Command.table[name.to_sym].new(_argv)
        end
      rescue => e
        abort(e.message)
      end
    end

    # @param argv [Array<String>]
    #   command arguments
    def initialize(argv)
      @argv = argv
      @optparse = make_option_parser
    end

    # Run the command.
    #
    # @return [void]
    def run
      raise NotImplementedError
    end
  end

  # CommandList provides the definition of "ghwikitools list".
  class CommandList < Command
    command :list
    describe "print all commands"

    def run
      puts "commands:"
      Command.table.keys.each do |key|
        puts "  %-10s %s" % [key, Command.table[key].description]
      end
    end
  end

  # CommandUpdate provides the definition of "ghwikitools update".
  class CommandUpdate < Command
    command :update
    describe "update header, footer, and other snippets"

    def run
      GHWikiTools::Page.all.each do |page|
        page.insert_header
        page.insert_footer
        page.update_snippets
      end
    end
  end
end

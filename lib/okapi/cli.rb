# encoding: utf-8
require 'optparse'

module Apiary
  module Okapi
    class CLI

      def initialize(args)
        case args.first
          when 'help'
            puts Apiary::Okapi::Help.show
          when 'version'
            puts VERSION
          when 'okapi'
            puts Apiary::Okapi::Help.okapi
          else
            run(parse_options!(args))
        end

        
      end

      def run(options)
        Apiary::Okapi::Test.new(options[:blueprint], options[:test_spec], options[:test_url], options[:output], options[:apiary_url]).run()

      end

      def parse_options!(args)
        options = {}
        options_parser = OptionParser.new do |opts|
          opts.on("-b", "--blueprint BLUEPRINT",
                  "path to the blueprint (default: " + BLUEPRINT_PATH + " )") do |blueprint|            
            options[:blueprint] = blueprint
          end

          opts.on("-t","--test_spec TEST_SPEC",
                  "path to the test specification (default: " + TEST_SPEC_PATH + " )") do |test_spec|            
            options[:test_spec] = test_spec
          end

          opts.on("-o","--output OUTPUT",
                  "output format (default" + OUTPUT + ")") do |output|
            options[:output] = output
          end

          opts.on("-u","--test_url TEST_URL",
                  "url to test (default" + TEST_URL + ")") do |test_url|
            options[:test_url] = test_url
          end

          opts.on("-a","--apiary APIARY",
                  "apiary url  (default" + APIARY_URL + ")") do |apiary|
            options[:apiary_url] = apiary
          end          

        end

        options_parser.parse!
        options[:blueprint]   ||= BLUEPRINT_PATH
        options[:test_spec]   ||= TEST_SPEC_PATH
        options[:output]      ||= OUTPUT
        options[:test_url]    ||= TEST_URL
        options[:apiary_url]  ||= APIARY_URL

        raise OptionParser::InvalidOption, 'Blueprint file "' + options[:blueprint] + '" does not exist' if not File.file?(options[:blueprint])
        raise OptionParser::InvalidOption, 'Test specification file "' + options[:test_spec] + '" does not exist' if not File.file?(options[:test_spec])
        
        options

      rescue OptionParser::InvalidOption => e
        puts e
        puts Apiary::Okapi::Help.banner
        exit 1
      end

    end
  end
end

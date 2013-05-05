# encoding: utf-8
require 'json'

module Apiary
  module Okapi
    class Parser

      attr_reader :data, :resources

      def initialize(spec_path)
        @data = read_file(spec_path)
      end

      def resources
        @resources ||= begin
          parse_data { |res|
            raise Exception, 'resource not defined' unless res["resource"]
            raise Exception, 'method not defined' unless res["method"]

            (@resources ||= []) << Apiary::Okapi::Resource.new(res["resource"], res["method"], res["params"])
          }
        @resources
        end
      end

      def read_file(path)
        @data = []
        File.open(path).each do |line|
          @data << line if line.strip != ""
        end
        @data
      end

      def parse_data
        @data.each { |res|
          splited = res.split(' ',3)

          begin
            splited[2] = JSON.parse splited[2] if splited[2] and splited[2] != ''
          rescue Exception => e
            raise Exception, 'can not parse parameters for resource:' + res + "(#{e})"
          end
          out = {
            'resource' => splited[1],
            'method' => splited[0],
            'params' => splited[2] || {}
            }
          yield out
        }
      end

    end
  end
end

# encoding: utf-8
require 'rest_client'

module Apiary
  module Okapi
    class Test
      def initialize(blueprint_path, test_spec_path, test_url, output, apiary_url)
        @blueprint_path = blueprint_path || BLUEPRINT_PATH
        @test_spec_path = test_spec_path || TEST_SPEC_PATH
        @test_url       = test_url || TEST_URL
        @output_format         = output || OUTPUT
        @apiary_url     = apiary_url || APIARY_URL
        @req_path       = GET_REQUESTS_PATH
        @res_path       = GET_RESULTS_PATH
        @connector = Apiary::Okapi::ApiaryConnector.new(@apiary_url, @req_path, @res_path)
        @output = []
        @resources = []
        @error = nil
        
      end

      def run(test)
        begin
          test()
        rescue Exception => e
          @error = e
        end
        
        Apiary::Okapi::Output.get(@output_format, @resources, @error)
      end

      def test
        prepare()
        if not @resources.empty?
          get_responses
          evaluate
        else
          raise Exception, 'No resources provided'
        end
      end

      def prepare
        resources = parse_test_spec(@test_spec_path)
        
        data = get_requests_spec(resources)

        raise Exception, 'Can not get request data from Apiary: ' + data[:error]  || '' if data[:error] or data[:resp].code.to_i != 200
         
        data[:data].each do |res|
          raise Exception, 'Resource error "' + res['error'] + '" for resource "' + res["method"] + ' ' + res["uri"]  + '"' if res['error']

          resources.each do |resource|
            if resource.uri == res["uri"] and resource.method == res["method"]
              resource.expanded_uri = res["expandedUri"]
              resource.body = res["body"]
              resource.headers = res["headers"]
              break
            end
          end
        end
        @resources = resources
      end

      def blueprint
        @blueprint ||= parse_blueprint(@blueprint_path)
      end

      def get_responses
        @resources.each { |resource|
          params = {:method => resource.method, :url => @test_url + resource.expanded_uri['url'], :headers => resource.headers || {}}
          begin            
            response = RestClient::Request.execute(params)

            raw_headers = response.raw_headers.inject({}) do |out, (key, value)|
                            out[key] = %w{ set-cookie }.include?(key.downcase) ? value : value.first
                            out
                          end

            resource.response =  Apiary::Okapi::Response.new(response.code, raw_headers, response.body)
          rescue Exception => e
            raise Exception, 'Can not get response for: ' + params.to_json + ' (' + e.to_s + ')'
          end
          }

      end

      def evaluate

        data = @connector.get_results(@resources, blueprint)

        raise Exception, 'Can not get evaluation data from apiary' + data[:error] || '' if data[:resp].code.to_i != 200 or data[:error]

        data[:data].each { |validation|
          @resources.each { |resource|
            if validation['resource']['uri'] == resource.uri and validation['resource']['method'] == resource.method
              resource.validation_result = Apiary::Okapi::ValidationResult.new()
              resource.validation_result.error = validation['errors']
              resource.validation_result.schema_res = validation["validations"]['reqSchemaValidations']
              resource.validation_result.body_pass = !validation["validations"]['reqData']['body']['isDifferent']
              resource.validation_result.body_diff = validation["validations"]['reqData']['body']['diff']
              resource.validation_result.header_pass = !validation["validations"]['reqData']['headers']['isDifferent']
              resource.validation_result.header_diff = validation["validations"]['reqData']['headers']['diff']

              resource.response.validation_result = Apiary::Okapi::ValidationResult.new()
              resource.response.validation_result.error = validation['errors']
              resource.response.validation_result.schema_res = validation["validations"]['resSchemaValidations']
              resource.response.validation_result.body_pass = !validation["validations"]['resData']['body']['isDifferent']
              resource.response.validation_result.body_diff = validation["validations"]['resData']['body']['diff']
              resource.response.validation_result.header_pass = !validation["validations"]['resData']['headers']['isDifferent']
              resource.response.validation_result.header_diff = validation["validations"]['resData']['headers']['diff']
            end

          }
        }
      end      

      def parse_test_spec(test_spec)
        Apiary::Okapi::Parser.new(test_spec).resources
      end

      def parse_blueprint(blueprint_path)
        File.read(blueprint_path)
      end

      def get_requests_spec(resources)
        @connector.get_requests(resources, blueprint)
      end

    end
  end
end


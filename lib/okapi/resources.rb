# encoding: utf-8
module Apiary
  module Okapi
    class Resource
      attr_accessor :uri, :method, :params, :expanded_uri,  :headers, :body, :response, :validation_result

      def initialize(uri, method, params, expanded_uri = nil,  headers = nil, body = nil, response = nil, validation_result = nil)
        #p uri, method, params
        @uri          = uri
        @method       = method
        @params       = params
        @expanded_uri = expanded_uri
        @headers      = headers
        @body         = body
        @response     = response
        @validation_result = validation_result
      end
    end

    class Response
      attr_accessor :status,  :headers, :body, :error, :validation_result

      def initialize(status = nil, headers = nil, body = nil, error = nil, validation_result = nil)
        @headers      = headers
        @body         = body
        @status       = status
        @error        = error
        @validation_result = validation_result
      end
    end

    class ValidationResult
      attr_accessor :status, :error, :schema_res , :body_pass, :body_diff, :header_pass, :header_diff

      def status
        @status ||= get_status
      end

      def get_status
#        p '@error and @headerPass and ((@schema and  @schemaPass) or (not @schema and @bodyPass))'
#
#        p @error
#        p @header_pass
#        p @schemaRes
#        p schema
#        p schema_pass
#        p @body_pass
#        p '#'
#        p (not @error and @header_pass and ((schema and  schema_pass) or (not schema and @body_pass)))
#        p (@header_pass and ((schema and  schema_pass) or (not schema and @body_pass)))
#        p (((schema and  schema_pass) or (not schema and @body_pass)))
#        p (((schema and  schema_pass)))
#        p (((not schema and @bodyPass)))
#        p (not @error)
#        p '----'
#        p @body_diff
#        p @header_diff
        return true if not @error and @header_pass and ((schema and  schema_pass) or (not schema and @body_pass))
        return false
      end

      def schema
        !(@schema_res == false)
      end

      def schema_pass
        not schema or schema and @schema_res and not @schema_res['errors']
      end

    end
  end
end

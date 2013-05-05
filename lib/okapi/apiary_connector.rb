# encoding: utf-8
require 'rest_client'
require 'json'

module Apiary
  module Okapi
    class ApiaryConnector

      attr_reader :apiary_url, :blueprint

      def initialize(apiary_url, req_path, res_path)
        @apiary_url = apiary_url
        @req_path = req_path
        @res_path  = res_path
      end

      def get_requests(resources, blueprint)

        resources_list = []

        resources.each() do |res|
          resources_list << {
            :resource =>  res.uri,
            :method =>  res.method,
            :params =>  res.params,
          }
        end

        data = {
          :resources => resources_list,
          :blueprint => blueprint
        }.to_json()

        begin
          response = RestClient.post @apiary_url + @req_path, data, :content_type => :json, :accept => :json
          data = JSON.parse(response.to_str)

          {:resp => response, :data => data['requests'], :status => data['status'], :error => data['error']}
        rescue Exception  => e
          {:resp => nil, :data => nil, :status => nil, :error => e}
        end

      end

      def get_results(resources, blueprint)

        resources_list = []
        resources.each() do |res|
          resources_list << {
            :request => {
              :uri =>  res.uri,
              :expandedUri => res.expanded_uri,
              :method =>  res.method,
              :headers =>  res.headers,
              :body =>  res.body,
            },
            :response => {
              :status =>  res.response.status,
              :headers => res.response.headers ,
              :body =>  res.response.body
            }
          }
        end

        data = {
          :resources => resources_list,
          :blueprint => blueprint
        }.to_json()

        begin
          response = RestClient.post @apiary_url + @res_path, data, :content_type => :json, :accept => :json

          data = JSON.parse(response.to_str)

          {:resp => response, :data => data['requests'], :status => data['status'], :error => data['error']}
        rescue Exception  => e
          {:resp => nil, :data => nil, :status => nil, :error => e}
        end
      end
    end
  end
end

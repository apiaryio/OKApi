Dir["#{File.dirname(__FILE__)}/outputs/*.rb"].each { |f|   require(f)  }

module Apiary
  module Okapi
    class Output
      def self.get(output,resources, error)
        Apiary::Okapi::Outputs.const_get(output.to_s.capitalize).send(:new, resources, error).get()
      end
    end
  end
end

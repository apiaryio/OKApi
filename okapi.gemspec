# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.expand_path('../lib/okapi/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "okapi"
  spec.version       = Apiary::Okapi::VERSION
  spec.authors       = ["Tu1ly"]
  spec.email         = ["tully@apiary.io"]
  spec.description   = %q{Apiary.io API tester - OKApi allows you to test if your documentation in Apiary Blueprint match your API}
  spec.summary       = %q{Apiary.io API tester - OKApi allows you to test if your documentation in Apiary Blueprint match your API}
  spec.homepage      = "http://apiary.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_dependency "rest-client"
end

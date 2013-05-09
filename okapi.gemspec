# coding: utf-8


Gem::Specification.new do |spec|
  spec.name          = "okapi"
  spec.version       = "0.1.1"
  spec.authors       = ["Tu1ly"]
  spec.email         = ["tully@apiary.io"]
  spec.description   = %q{OKApi has been merged into Apiary.io CLI [https://rubygems.org/gems/apiaryio]}
  spec.summary       = %q{OKApi has been merged into Apiary.io CLI [https://rubygems.org/gems/apiaryio]}
  spec.homepage      = "http://apiary.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)

  spec.add_dependency "json"
  spec.add_dependency "rest-client"
end

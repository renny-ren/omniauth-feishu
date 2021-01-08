require_relative 'lib/omniauth/feishu/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-feishu"
  spec.version       = Omniauth::Feishu::VERSION
  spec.authors       = ["Renny"]
  spec.email         = ["rennyallen@hotmail.com"]

  spec.summary       = "Lark(Feishu) OAuth2 Strategy for OmniAuth"
  spec.homepage      = "https://github.com/renny-ren/omniauth-feishu"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.license       = "MIT"

  spec.add_dependency "omniauth-oauth2", "~> 1.6.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

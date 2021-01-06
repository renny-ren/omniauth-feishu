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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'letter_opener_web_s3/version'

Gem::Specification.new do |spec|
  spec.name          = "letter_opener_web_s3"
  spec.version       = LetterOpenerWebS3::VERSION
  spec.authors       = ["Vital Ryabchinskiy"]
  spec.email         = ["vital.ryabchinskiy@gmail.com"]


  spec.description   = "Gives letter_opener and letter_opener_web work with S3"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/vitalinfo/letter_opener_web_s3"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rails", "~> 4.0"
  spec.add_dependency "letter_opener_web", "~> 1.3"
  spec.add_dependency "aws-sdk", "~> 2"
end

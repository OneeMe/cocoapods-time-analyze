lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-time-analyze/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-time-analyze'
  spec.version       = CocoapodsTimeAnalyze::VERSION
  spec.authors       = ['Forelax']
  spec.email         = ['helloworldmkv@163.com']
  spec.description   = 'A cocoapods plugin to analyze time of cocoapods pod install and xcodebuild.'
  spec.summary       = 'A cocoapods plugin to analyze time of cocoapods pod install and xcodebuild.'
  spec.homepage      = 'https://github.com/Forelax/cocoapods-time-analyze'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'cocoapods', '~> 1.5'
  spec.add_development_dependency 'fakefs', '~> 0.13'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.58'
  spec.add_development_dependency 'ruby-debug-ide', '~> 0.6'
  spec.add_development_dependency 'gem-release', '~> 2.0'
end

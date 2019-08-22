# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'captchah/version'

Gem::Specification.new do |spec|
  spec.name          = 'captchah'
  spec.version       = Captchah::VERSION
  spec.authors       = ['Evgeni Radev']
  spec.email         = ['evgeniradev@gmail.com']
  spec.summary       =
    'A Rails captcha gem that attempts to determine whether or not a ' \
    'user is human.'
  spec.requirements << 'You must have ImageMagick or GraphicsMagick installed.'
  spec.homepage      = 'https://github.com/evgeniradev/captchah'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.require_paths = ['lib']
  spec.files = Dir[
    '{app,config,lib}/**/*', 'MIT-LICENSE', 'README.md'
  ]

  spec.add_dependency 'mini_magick', '~> 4.0'
  spec.add_dependency 'rails', '~> 5.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop-rails', '~> 2.3'
end

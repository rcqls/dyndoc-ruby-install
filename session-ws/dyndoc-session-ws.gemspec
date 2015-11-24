Gem::Specification.new do |s|
  s.name              = 'dyndoc-session-ws'
  s.version           = '0.1.0'
  s.summary           = 'Dyndoc Session Manager'
  s.author            = 'rcqls'
  s.email             = 'rdrouilh@gmail.com'
  s.homepage          = 'http://github.com/rcqls/dyndocker'
  s.license           = 'MIT'

  s.files = %w[config.ru start.sh] +
            Dir.glob('extra/**/*.conf') +
            Dir.glob('**/*.rb')

  s.add_dependency 'faye-websocket', '>= 0.10.1'
  s.add_dependency 'eventmachine', '>= 0.12.0'
  s.add_dependency 'websocket-driver', '>= 0.5.1'

  s.add_development_dependency 'permessage_deflate'
  s.add_development_dependency 'progressbar'
  s.add_development_dependency 'puma', '>= 2.0.0', '< 2.15.0'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-eventmachine', '>= 0.2.0'

  jruby = RUBY_PLATFORM =~ /java/
  rbx   = defined?(RUBY_ENGINE) && RUBY_ENGINE =~ /rbx/

  unless jruby
    s.add_development_dependency 'rainbows', '~> 4.4.0'
    s.add_development_dependency 'thin', '>= 1.2.0'
  end

  unless rbx or RUBY_VERSION < '1.9'
    s.add_development_dependency 'goliath'
  end

  unless jruby or rbx
    s.add_development_dependency 'passenger', '>= 4.0.0'
  end
end
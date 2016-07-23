Gem::Specification.new do |s|
  s.name = 'monthly_planner'
  s.version = '0.3.1'
  s.summary = 'Stores upcoming dates for the month primarily in a plain text file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/monthly_planner.rb']
  s.add_runtime_dependency('dynarex', '~> 1.7', '>=1.7.11')
  s.add_runtime_dependency('fuzzy_match', '~> 2.1', '>=2.1.0')
  s.add_runtime_dependency('chronic', '~> 0.10', '>=0.10.2')
  s.signing_key = '../privatekeys/monthly_planner.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/monthly_planner'
end

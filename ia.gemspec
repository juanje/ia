# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','ia_version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'ia'
  s.version = Ia::VERSION
  s.author = 'JoseAlberto Suárez López'
  s.email = 'jasuarez@emergya.com'
  s.homepage = ''
  s.platform = Gem::Platform::RUBY
  s.summary = 'Internet Automator'
# Add your other files here if you make them
  s.files = %w(
bin/ia
lib/ia_apache.rb
lib/ia_drupal.rb
lib/ia_fs.rb
lib/ia_queca.rb
lib/ia_redmine.rb
lib/ia_svn.rb
lib/ia_utils.rb
lib/ia_version.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','ia.rdoc']
  s.rdoc_options << '--title' << 'ia' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'ia'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_dependency('gli')
  s.add_dependency('rainbow')
  s.add_dependency('simple_progressbar')
end

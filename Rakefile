require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/unfuzzle/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'unfuzzle'
  s.version          = Unfuzzle::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "This gem does ... "
  s.author           = 'First Last'
  s.email            = 'user@example.com'
  s.homepage         = 'http://my-site.net'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib,test}/**/*")
  
  s.add_dependency('json', '>= 1.1.6')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end
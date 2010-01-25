begin
  $: << 'lib'; %w( rubygems rake/testtask rake/rdoctask rake/gempackagetask ).each { |dep| require dep }
rescue LoadError => e
  puts "LoadError: you might want to try running the setup task first."
  raise e
end

runtime_deps = YAML::load_file( 'dependencies.yml' )
developer_deps = { :bacon => '~> 1.0', :facon => '~> 0.4' }

gem = Gem::Specification.new do |gem|
  gem.name = "waves"
  gem.rubyforge_project = "waves"
  gem.summary = "Open-source framework for building Ruby-based Web applications."
  gem.version = File.read('doc/VERSION')
  gem.homepage = 'http://rubywaves.com'
  gem.author = 'Dan Yoder'
  gem.email = 'dan@zeraweb.com'
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8.6'
  runtime_deps.each { | name, version | gem.add_runtime_dependency( name.to_s, version ) }
  developer_deps.each { |name, version| gem.add_development_dependency( name.to_s, version ) }
  gem.files = FileList[ 'templates/**/*', 'templates/**/.gitignore', 'lib/**/*.rb',
    'lib/**/*.erb', "{doc,samples,templates,test}/**/*", 'dependencies.yml' ]
  gem.has_rdoc = true
  gem.bindir = 'bin'
  gem.executables = [ 'waves' ]
end

desc "Create the waves gem"
task( :package => [ :clean, :rdoc, :gemspec ] ) { Gem::Builder.new( gem ).build }

desc "Clean build artifacts"
task( :clean ) { FileUtils.rm_rf Dir['*.gem', '*.gemspec'] }

desc "Rebuild and Install Waves as a gem"
task( :install => [ :package, :install_gem ] )

desc "Install Waves as a local gem"
task( :install_gem ) do
    require 'rubygems/installer'
    Dir['*.gem'].each do |gem|
      Gem::Installer.new(gem).install
    end
end

desc "create .gemspec file (useful for github)"
task :gemspec do
  filename = "#{gem.name}.gemspec"
  File.open(filename, "w") do |f|
    f.puts gem.to_ruby
  end
end


# based on a blog post by Assaf Arkin
desc "Set up dependencies so you can work from source"
task( :setup ) do
  gems = Gem::SourceIndex.from_installed_gems
  # Runtime dependencies from the Gem's spec.
  dependencies = gem.dependencies
  # Add build-time dependencies, like this:
  dependencies.each do |dep|
    if gems.find_name(dep.name, dep.version_requirements).empty?
      if dep.name =~ /spicycode-micronaut/
        puts "\n\n***\nYou will need to install micronaut by hand.\n  # gem sources -a http://gems.github.com\n   # (sudo) gem install spicycode- micronaut\n\n"
        raise LoadError, "Required dependency 'micronaut' missing. Install by hand through github gem."
      end

      puts "Installing dependency: #{dep}"
      begin
        require 'rubygems/dependency_installer'
        if Gem::RubyGemsVersion =~ /^1\.0\./
          Gem::DependencyInstaller.new(dep.name, dep.version_requirements).install
        else
          # as of 1.1.0
          Gem::DependencyInstaller.new.install(dep.name, dep.version_requirements)
        end
      rescue LoadError # < rubygems 1.0.1
        require 'rubygems/remote_installer'
        Gem::RemoteInstaller.new.install(dep.name, dep.version_requirements)
      end
    end
  end
  system(cmd = "chmod +x bin/waves*")
  puts "rake setup task completed... happy hacking!"
end

namespace :specs do
  require "rubygems"
    require "micronaut/rake_task"

  # Sneaky hidy.
  desc "Run all specs."
  Micronaut::RakeTask.new :run do |t|
   t.pattern = "spec/**/*_spec.rb"
  end
end

desc "Run all old-style tests and specs under test/"
task( :test ) do
  paths = FileList['test/**/*.rb'].exclude('**/helpers.rb')
  puts command = "bacon #{paths.join(' ')}"
  system command
end

desc "Run all specs and tests."
task :spec => %w[ test specs:run ]


Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'doc/README'
  rdoc.rdoc_files.add [ 'lib/**/*.rb', 'doc/*' ]
end

task( :rdoc_publish => :rdoc ) do
  path = "/var/www/gforge-projects/#{gem.name}/"
  `rsync -a --delete ./doc/rdoc/ dyoder67@rubyforge.org:#{path}`
end


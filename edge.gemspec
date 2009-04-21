# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{edge}
  s.version = "2009.04.21.19.08"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2009-04-21}
  s.default_executable = %q{waves}
  s.email = %q{dan@zeraweb.com}
  s.executables = ["waves"]
  s.files = ["templates/classic", "templates/classic/configurations", "templates/classic/configurations/default.rb.erb", "templates/classic/configurations/development.rb.erb", "templates/classic/configurations/production.rb.erb", "templates/classic/controllers", "templates/classic/helpers", "templates/classic/lib", "templates/classic/lib/tasks", "templates/classic/models", "templates/classic/public", "templates/classic/public/css", "templates/classic/public/flash", "templates/classic/public/images", "templates/classic/public/javascript", "templates/classic/Rakefile", "templates/classic/resources", "templates/classic/resources/map.rb.erb", "templates/classic/schema", "templates/classic/schema/migrations", "templates/classic/startup.rb.erb", "templates/classic/templates", "templates/classic/templates/errors", "templates/classic/templates/errors/not_found_404.mab", "templates/classic/templates/errors/server_error_500.mab", "templates/classic/templates/layouts", "templates/classic/templates/layouts/default.mab", "templates/classic/tmp", "templates/classic/tmp/sessions", "templates/classic/views", "templates/compact", "templates/compact/startup.rb.erb", "templates/classic/controllers/.gitignore", "templates/classic/helpers/.gitignore", "templates/classic/lib/tasks/.gitignore", "templates/classic/models/.gitignore", "templates/classic/public/css/.gitignore", "templates/classic/public/flash/.gitignore", "templates/classic/public/images/.gitignore", "templates/classic/public/javascript/.gitignore", "templates/classic/resources/.gitignore", "templates/classic/schema/migrations/.gitignore", "templates/classic/tmp/sessions/.gitignore", "templates/classic/views/.gitignore", "lib/waves/caches/file.rb", "lib/waves/caches/memcached.rb", "lib/waves/caches/simple.rb", "lib/waves/caches/synchronized.rb", "lib/waves/commands/console.rb", "lib/waves/commands/generate.rb", "lib/waves/commands/help.rb", "lib/waves/commands/server.rb", "lib/waves/dispatchers/base.rb", "lib/waves/dispatchers/default.rb", "lib/waves/ext/float.rb", "lib/waves/ext/hash.rb", "lib/waves/ext/integer.rb", "lib/waves/ext/kernel.rb", "lib/waves/ext/module.rb", "lib/waves/ext/object.rb", "lib/waves/ext/string.rb", "lib/waves/ext/symbol.rb", "lib/waves/ext/tempfile.rb", "lib/waves/foundations/classic.rb", "lib/waves/foundations/compact.rb", "lib/waves/helpers/basic.rb", "lib/waves/helpers/doc_type.rb", "lib/waves/helpers/extended.rb", "lib/waves/helpers/form.rb", "lib/waves/helpers/formatting.rb", "lib/waves/helpers/layouts.rb", "lib/waves/helpers/model.rb", "lib/waves/helpers/view.rb", "lib/waves/layers/inflect/english.rb", "lib/waves/layers/mvc/controllers.rb", "lib/waves/layers/mvc/extensions.rb", "lib/waves/layers/mvc.rb", "lib/waves/layers/orm/migration.rb", "lib/waves/layers/orm/providers/active_record/tasks/generate.rb", "lib/waves/layers/orm/providers/active_record/tasks/schema.rb", "lib/waves/layers/orm/providers/active_record.rb", "lib/waves/layers/orm/providers/data_mapper.rb", "lib/waves/layers/orm/providers/filebase.rb", "lib/waves/layers/orm/providers/sequel/tasks/generate.rb", "lib/waves/layers/orm/providers/sequel/tasks/schema.rb", "lib/waves/layers/orm/providers/sequel.rb", "lib/waves/layers/rack/rack_cache.rb", "lib/waves/layers/renderers/erubis.rb", "lib/waves/layers/renderers/haml.rb", "lib/waves/layers/renderers/markaby.rb", "lib/waves/matchers/accept.rb", "lib/waves/matchers/base.rb", "lib/waves/matchers/ext.rb", "lib/waves/matchers/path.rb", "lib/waves/matchers/query.rb", "lib/waves/matchers/request.rb", "lib/waves/matchers/resource.rb", "lib/waves/matchers/traits.rb", "lib/waves/matchers/uri.rb", "lib/waves/renderers/mixin.rb", "lib/waves/resources/mixin.rb", "lib/waves/resources/paths.rb", "lib/waves/runtime/configuration.rb", "lib/waves/runtime/console.rb", "lib/waves/runtime/logger.rb", "lib/waves/runtime/mime_types.rb", "lib/waves/runtime/mocks.rb", "lib/waves/runtime/monitor.rb", "lib/waves/runtime/rackup.rb", "lib/waves/runtime/request.rb", "lib/waves/runtime/response.rb", "lib/waves/runtime/response_mixin.rb", "lib/waves/runtime/runtime.rb", "lib/waves/runtime/server.rb", "lib/waves/runtime/session.rb", "lib/waves/runtime/worker.rb", "lib/waves/servers/base.rb", "lib/waves/servers/mongrel.rb", "lib/waves/servers/webrick.rb", "lib/waves/tasks/gem.rb", "lib/waves/tasks/generate.rb", "lib/waves/views/errors.rb", "lib/waves/views/mixin.rb", "lib/waves.rb", "lib/waves/layers/orm/providers/active_record/migrations/empty.rb.erb", "lib/waves/layers/orm/providers/sequel/migrations/empty.rb.erb", "doc/HISTORY", "doc/LICENSE", "doc/README", "doc/VERSION", "samples/basic", "samples/basic/basic_startup.rb", "samples/basic/config.ru", "samples/blog", "samples/blog/configurations", "samples/blog/configurations/default.rb", "samples/blog/configurations/development.rb", "samples/blog/configurations/production.rb", "samples/blog/models", "samples/blog/models/comment.rb", "samples/blog/models/entry.rb", "samples/blog/public", "samples/blog/public/css", "samples/blog/public/css/site.css", "samples/blog/public/javascript", "samples/blog/public/javascript/jquery-1.2.6.min.js", "samples/blog/public/javascript/site.js", "samples/blog/Rakefile", "samples/blog/resources", "samples/blog/resources/entry.rb", "samples/blog/resources/map.rb", "samples/blog/schema", "samples/blog/schema/migrations", "samples/blog/schema/migrations/001_initial_schema.rb", "samples/blog/schema/migrations/002_add_comments.rb", "samples/blog/schema/migrations/templates", "samples/blog/schema/migrations/templates/empty.rb.erb", "samples/blog/startup.rb", "samples/blog/templates", "samples/blog/templates/comment", "samples/blog/templates/comment/add.mab", "samples/blog/templates/comment/list.mab", "samples/blog/templates/entry", "samples/blog/templates/entry/edit.mab", "samples/blog/templates/entry/list.mab", "samples/blog/templates/entry/show.mab", "samples/blog/templates/entry/summary.mab", "samples/blog/templates/errors", "samples/blog/templates/errors/not_found_404.mab", "samples/blog/templates/errors/server_error_500.mab", "samples/blog/templates/layouts", "samples/blog/templates/layouts/default.mab", "samples/blog/templates/waves", "samples/blog/templates/waves/status.mab", "samples/blog/tmp", "samples/blog/tmp/sessions", "test/ext", "test/ext/object.rb", "test/ext/shortcuts.rb", "test/helpers.rb", "test/match", "test/match/accept.rb", "test/match/ext.rb", "test/match/methods.rb", "test/match/params.rb", "test/match/path.rb", "test/match/query.rb", "test/match/request.rb", "test/match/uri.rb", "test/process", "test/process/request.rb", "test/process/resource.rb", "test/resources", "test/resources/path.rb", "test/runtime", "test/runtime/configurations.rb", "test/runtime/request.rb", "test/runtime/response.rb", "test/views", "test/views/templates", "test/views/templates/test", "test/views/templates/test/smurf.mab", "test/views/views.rb", "bin/waves"]
  s.has_rdoc = true
  s.homepage = %q{http://rubywaves.com}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{waves}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Open-source framework for building Ruby-based Web applications.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<autocode>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<extensions>, ["~> 0.6"])
      s.add_runtime_dependency(%q<rack>, ["~> 0.4"])
      s.add_runtime_dependency(%q<choice>, ["~> 0.1"])
      s.add_runtime_dependency(%q<filebase>, [">= 0.3.5"])
      s.add_runtime_dependency(%q<english>, ["~> 0.3"])
      s.add_runtime_dependency(%q<rack-cache>, ["~> 0.2"])
      s.add_runtime_dependency(%q<RedCloth>, ["~> 4.0"])
      s.add_runtime_dependency(%q<live_console>, ["~> 0.2"])
      s.add_runtime_dependency(%q<metaid>, ["~> 1.0"])
      s.add_runtime_dependency(%q<functor>, [">= 0.5.0"])
      s.add_runtime_dependency(%q<daemons>, ["~> 1.0.10"])
      s.add_runtime_dependency(%q<rakegen>, ["~> 0.6"])
      s.add_development_dependency(%q<bacon>, ["~> 1.0"])
      s.add_development_dependency(%q<facon>, ["~> 0.4"])
    else
      s.add_dependency(%q<autocode>, [">= 1.0.0"])
      s.add_dependency(%q<extensions>, ["~> 0.6"])
      s.add_dependency(%q<rack>, ["~> 0.4"])
      s.add_dependency(%q<choice>, ["~> 0.1"])
      s.add_dependency(%q<filebase>, [">= 0.3.5"])
      s.add_dependency(%q<english>, ["~> 0.3"])
      s.add_dependency(%q<rack-cache>, ["~> 0.2"])
      s.add_dependency(%q<RedCloth>, ["~> 4.0"])
      s.add_dependency(%q<live_console>, ["~> 0.2"])
      s.add_dependency(%q<metaid>, ["~> 1.0"])
      s.add_dependency(%q<functor>, [">= 0.5.0"])
      s.add_dependency(%q<daemons>, ["~> 1.0.10"])
      s.add_dependency(%q<rakegen>, ["~> 0.6"])
      s.add_dependency(%q<bacon>, ["~> 1.0"])
      s.add_dependency(%q<facon>, ["~> 0.4"])
    end
  else
    s.add_dependency(%q<autocode>, [">= 1.0.0"])
    s.add_dependency(%q<extensions>, ["~> 0.6"])
    s.add_dependency(%q<rack>, ["~> 0.4"])
    s.add_dependency(%q<choice>, ["~> 0.1"])
    s.add_dependency(%q<filebase>, [">= 0.3.5"])
    s.add_dependency(%q<english>, ["~> 0.3"])
    s.add_dependency(%q<rack-cache>, ["~> 0.2"])
    s.add_dependency(%q<RedCloth>, ["~> 4.0"])
    s.add_dependency(%q<live_console>, ["~> 0.2"])
    s.add_dependency(%q<metaid>, ["~> 1.0"])
    s.add_dependency(%q<functor>, [">= 0.5.0"])
    s.add_dependency(%q<daemons>, ["~> 1.0.10"])
    s.add_dependency(%q<rakegen>, ["~> 0.6"])
    s.add_dependency(%q<bacon>, ["~> 1.0"])
    s.add_dependency(%q<facon>, ["~> 0.4"])
  end
end

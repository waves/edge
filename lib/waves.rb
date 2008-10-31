# External Dependencies
require 'rack'
require 'daemons'

# a bunch of handy stuff
require 'extensions/io'
require 'extensions/symbol' unless Symbol.instance_methods.include? 'to_proc'
require 'fileutils'
require 'metaid'
require 'forwardable'
require 'date'
require 'benchmark'
require 'base64'

require 'functor'
require 'filebase'
require 'filebase/model'

require 'english/style'

# selected project-specific extensions
require 'ext/integer'
require 'ext/float'
require 'ext/string'
require 'ext/symbol'
require 'ext/hash'
require 'ext/tempfile'
require 'ext/module'
require 'ext/object'
require 'ext/kernel'

# waves Runtime
require 'servers/base'
require 'servers/webrick'
require 'servers/mongrel'
require 'dispatchers/base'
require 'dispatchers/default'
require 'runtime/logger'
require 'runtime/mime_types'
require 'runtime/runtime'
require 'runtime/worker'
require 'runtime/request'
require 'runtime/response'
require 'runtime/response_mixin'
require 'runtime/session'
require 'runtime/configuration'
require 'caches/simple'

# waves URI mapping
require 'matchers/base'
require 'matchers/accept'
require 'matchers/content_type'
require 'matchers/path'
require 'matchers/query'
require 'matchers/traits'
require 'matchers/uri'
require 'matchers/request'
require 'matchers/resource'
require 'resources/paths'
require 'resources/mixin'

require 'views/mixin'
require 'views/errors'
require 'renderers/mixin'
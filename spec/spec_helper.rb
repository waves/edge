require "rubygems"
  require "micronaut"

Micronaut.configure {|config| config.mock_with :rr }

# Framework libs go in front
#
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require 'waves'
require 'waves/runtime/mocks'

Waves::Runtime.instance = Waves::Runtime.new
include Waves::Mocks


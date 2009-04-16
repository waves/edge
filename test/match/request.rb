require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require "test/helpers.rb"

require "waves/foundations/compact"
require "waves/matchers/request"

describe "Top-level request matcher" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  # @todo Change these to mocks to ensure we really are dealing
  #       with a non-constructed URI matcher.

  feature "matches any URI, returning {}, if URI matcher omitted" do
    m = Waves::Matchers::Request.new  :path => nil,
                                      :host => nil,
                                      :port => nil,
                                      :scheme => nil

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")
    m.call(request).should == {}

    request = Waves::Request.new env("http://example2.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")
    m.call(request).should == {}

    request = Waves::Request.new env("http://example2.com:8008/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")
    m.call(request).should == {}
  end
end





#      def initialize(options)
#        # Simplest to fake it if there is no URL to match
#        @uri = Matchers::URI.new(options) rescue lambda { {} }
#
#        @constraints = {}
#
#        # These are essentially optional
#        maybe { @constraints[:accept] = Matchers::Accept.new options }
#        maybe { @constraints[:ext]    = Matchers::Ext.new options[:ext] }
#        maybe { @constraints[:query]  = Matchers::Query.new options[:query] }
#        maybe { @constraints[:traits] = Matchers::Traits.new options[:traits] }

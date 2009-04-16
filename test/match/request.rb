require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require "test/helpers.rb"

require "waves/foundations/compact"
require "waves/matchers/request"

describe "Top-level request matcher with no path given" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "always matches and returns {} if no server/scheme given either" do
#    m = Waves::Matchers::Request.new  :path => nil,
#                                      :server => nil,
#                                      :scheme => nil
#
#    request = Waves::Request.new env("http://example.com/moo",
#                                     :method => "GET",
#                                     "HTTP_ACCEPT" => "text/html")
#
#    m.call(request).should == {}
  end

  feature "matches returning {} when server and scheme match (if present)" do
    m = Waves::Matchers::Request.new  :path => nil,
                                      :server => "example.com",
                                      :scheme => nil

#    n = Waves::Matchers::Request.new  :path => nil,
#                                      :server => nil,
#                                      :scheme => "http"
#
#    o = Waves::Matchers::Request.new  :path => nil,
#                                      :server => "example.com",
#                                      :scheme => "http"
#
    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    m.call(request).should == {}
#    n.call(request).should == {}
#    o.call(request).should == {}
  end

  feature "returns false if either server or scheme fail to match when given" do
#    m = Waves::Matchers::Request.new  :path => nil,
#                                      :server => "example.com",
#                                      :scheme => nil
#
#    n = Waves::Matchers::Request.new  :path => nil,
#                                      :server => nil,
#                                      :scheme => "https"
#
#    request = Waves::Request.new env("http://example2.com/moo",
#                                     :method => "GET",
#                                     "HTTP_ACCEPT" => "text/html")
#
#    m.call(request).should == false
#    n.call(request).should == false
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

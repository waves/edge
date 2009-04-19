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

  feature "omits Accept constraints if none given" do
    Waves::Matchers::Request.new({}).constraints.has_key?(:accept).should == false
  end

  feature "omits Ext constraints if none given" do
    Waves::Matchers::Request.new({}).constraints.has_key?(:ext).should == false
  end

  feature "omits Query constraints if none given" do
    Waves::Matchers::Request.new({}).constraints.has_key?(:query).should == false
  end

  feature "omits Traits constraints if none given" do
    Waves::Matchers::Request.new({}).constraints.has_key?(:traits).should == false
  end

  feature "returns captured values when matched" do
    m = Waves::Matchers::Request.new  :path => [:something],
                                      :host => nil,
                                      :port => nil,
                                      :scheme => nil

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    res = m.call request
    res.kind_of?(Hash).should == true
    res.size.should == 1
    res.has_key?(:something).should == true
  end

  feature "sets the captured trait to return value when matched" do
    m = Waves::Matchers::Request.new  :path => [:something],
                                      :host => nil,
                                      :port => nil,
                                      :scheme => nil

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    res = m.call request
    request.traits.waves.captured.something.should == res[:something]
  end

end


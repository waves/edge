require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require "test/helpers.rb"

require "waves/foundations/compact"
require "waves/matchers/URI"

describe "URI matcher without specified path" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "always matches and returns {} if no host/port/scheme given either" do
    m = Waves::Matchers::URI.new  :path => nil,
                                  :host => nil,
                                  :port => nil,
                                  :scheme => nil

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    m.call(request).should == {}
  end

  feature "matches returning {} when all of given host/port/scheme match" do
    m = Waves::Matchers::URI.new  :path => nil,
                                  :host => "example.com",
                                  :port => nil,
                                  :scheme => nil

    n = Waves::Matchers::URI.new  :path => nil,
                                  :host => nil,
                                  :port => nil,
                                  :scheme => "http"

    o = Waves::Matchers::URI.new  :path => nil,
                                  :host => nil,
                                  :port => nil,
                                  :scheme => "http"

    q = Waves::Matchers::URI.new  :path => nil,
                                  :host => "example.com",
                                  :port => 80,
                                  :scheme => "http"

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    m.call(request).should == {}
    n.call(request).should == {}
    o.call(request).should == {}
    q.call(request).should == {}
  end

  feature "returns falseish if either host, port or scheme fail to match when given" do
    m = Waves::Matchers::URI.new  :path => nil,
                                  :host => "example.com",
                                  :port => nil,
                                  :scheme => nil

    n = Waves::Matchers::URI.new  :path => nil,
                                  :host => nil,
                                  :port => nil,
                                  :scheme => "https"

    o = Waves::Matchers::URI.new  :path => nil,
                                  :host => nil,
                                  :port => 8080,
                                  :scheme => nil

    request = Waves::Request.new env("http://example2.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    (!!m.call(request)).should == false
    (!!n.call(request)).should == false
    (!!o.call(request)).should == false
  end
end

describe "URI matcher with path specified" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "returns path captures if path and any present host/port/scheme match" do
    m = Waves::Matchers::URI.new  :path => [:aminal],
                                  :host => "example.com",
                                  :port => nil,
                                  :scheme => "http"

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    m.call(request).should == {:aminal => "moo"}
  end

  feature "returns falseish if path matches but a present host/port/scheme does not" do
    m = Waves::Matchers::URI.new  :path => [:aminal],
                                  :host => "example2.com",
                                  :port => nil,
                                  :scheme => nil

    n = Waves::Matchers::URI.new  :path => [:aminal],
                                  :host => nil,
                                  :port => 8008,
                                  :scheme => nil

    o = Waves::Matchers::URI.new  :path => [:aminal],
                                  :host => nil,
                                  :port => nil,
                                  :scheme => "https"

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/html")

    (!!m.call(request)).should == false
    (!!n.call(request)).should == false
    (!!o.call(request)).should == false
  end
end

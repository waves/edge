require "#{File.dirname(__FILE__)}/../helpers.rb"

describe "An instance of Waves::Response" do

  before do
    @request = Waves::Request.new(env( '/', :method => 'GET' ))
    @response = Waves::Response.new(@request)
  end

  it "has a Rack::Response" do
    @response.rack_response.class.should == Rack::Response
  end

  it "has a Waves::Request" do
    @response.request.class.should == Waves::Request
  end

  it "can access the session for the current request" do
    @response.session.class.should == Waves::Session
  end

  it "provides setter methods for commonly used headers" do
    @response.rack_response.should.receive(:[]=).with('Content-Type', 'text/javascript')
    @response.content_type = 'text/javascript'

    @response.rack_response.should.receive(:[]=).with('Content-Length', '42')
    @response.content_length = '42'

    @response.rack_response.should.receive(:[]=).with('Location', '/here/')
    @response.location = '/here/'

    @response.rack_response.should.receive(:[]=).with('Expires', 'Thu, 09 Aug 2007 05:22:55 GMT')
    @response.expires = 'Thu, 09 Aug 2007 05:22:55 GMT'
  end

  it "delegates unknown methods to the Rack response" do
    @response.rack_response.should.receive(:mclintock!)
    @response.mclintock!
  end

end
require 'waves/foundations/compact'
describe "Response Content-Type header " do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  it "Should set the default content type to text/html" do
    Test::Resources::Map.on(:get, ["foo"]) { }

    resp = get "/foo"
    resp.status.should == 200
    resp.content_type.should == 'text/html'

  end

  it "Should return the content type in accept if there is no extension" do

    Test::Resources::Map.on(:get, ["foo"], :accept => "text/javascript") { }
    resp = get "/foo", "HTTP_ACCEPT" => "text/javascript"
    resp.status.should == 200
    resp.content_type.should == 'text/javascript'
  end

  it "Should return  content type of ext when its set." do
    Test::Resources::Map.on(:get, ["foo"], :ext => [:js], :accept => "text/html") { }

    resp = get "/foo.js", "HTTP_ACCEPT" => "text/html"
    resp.status.should == 200
    resp.content_type.should == 'text/javascript'
  end

end

describe "Waves::Response#finish" do

  before do
    @request = Waves::Request.new(env( '/', :method => 'GET' ))
    @response = Waves::Response.new(@request)
  end

  it "saves the request session and calls Rack::Response#finish" do
    @response.rack_response.should.receive(:finish)
    @response.finish
  end

end

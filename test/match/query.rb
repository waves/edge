require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'waves/foundations/compact'

describe "Matching Query Parameters" do

  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "Test for a query parameter using true" do
    Test::Resources::Map.on(:get, ["foo"], :accept => "text/plain",
                                           :query => {:bar => true}) { }

    resp = get "/foo?bar=baz", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 200

    resp = get "/foo", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 404
  end

  feature "Test that a query parameter matches a regexp" do
    Test::Resources::Map.on(:get, ["foo"], :accept => "text/plain",
                                           :query => {:bar => /\d+/}) { }

    resp = get "/foo?bar=123", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 200

    resp = get "/foo?bar=baz", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 404
  end

  feature "Test that a query parameter matches a string" do
    Test::Resources::Map.on(:get, ["foo"], :accept => "text/plain",
                                           :query => {:bar => "123"}) { }

    resp = get "/foo?bar=123", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 200

    resp = get "/foo?bar=baz", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 404
  end

  feature "Test that a query parameter satisfies a lambda condition" do
    Test::Resources::Map.on(:get, ["foo"], :accept => "text/plain",
                                           :query => {:bar => lambda {|x| x == "123" }}) { }

    resp = get "/foo?bar=123", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 200

    resp = get "/foo?bar=baz", "HTTP_ACCEPT" => "text/plain"
    resp.status.should == 404
  end

end

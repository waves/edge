require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'test/helpers.rb'
require 'waves/foundations/compact'

describe "Matching The Accepts Header" do

  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "Match an implied accept header using the file extension" do
    Test::Resources::Map.on(:get, true, :ext => [:js] ) {}
    get("/foo.js").status.should == 200

    get("/foo").status.should == 404
  end

  feature "Match a MIME subtype from the Accept header" do
    Test::Resources::Map.on(:get, true, :accept => :javascript) {}

    get("/foo", {"HTTP_ACCEPT" => "text/javascript"}).status.should == 200

    get("/foo").status.should == 404
  end

  feature "Match against an array of options from the Accept header" do
    Test::Resources::Map.on(:get, true, :accept => [:javascript, :css]) {}

    get("/foo", {"HTTP_ACCEPT" => "text/javascript"}).status.should == 200
    get("/foo", {"HTTP_ACCEPT" => "text/css"}).status.should == 200
    get("/foo", {"HTTP_ACCEPT" => "text/css,text/javascript"}).status.should == 200

    get("/foo").status.should == 404
  end

  feature "Match against a MIME-type (rather than subtype) from the Accept header" do
    Test::Resources::Map.on(:get, true, :accept => :image) {}

    get("/foo", {"HTTP_ACCEPT" => "image/png"}).status.should == 200
    get("/foo", {"HTTP_ACCEPT" => "image/*"}).status.should == 200

    get("/foo").status.should == 404
  end

end

require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'test/helpers.rb'

require 'waves/foundations/compact'
require "waves/runtime/mime_types"

describe "Requested header matching" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "matches correct MIME given as a file extension" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/javascript") { }

    resp = get "/foo.js"
    resp.status.should == 200
  end

  feature "matches correct MIME given in the Requested header" do
    Test::Resources::Map.on(:get,
                            ["foo"],
                            :requested => "text/javascript") { }

    resp = get "/foo", "HTTP_ACCEPT" => "text/javascript"
    resp.status.should == 200
  end

  feature "allows both a file extension and Requested" do
    Test::Resources::Map.on(:get,
                            ["foo"],
                            :requested => "text/javascript") { }

    resp = get "/foo.js", "HTTP_ACCEPT" => "text/javascript"
    resp.status.should == 200
  end

  feature "prefers a present file extension over any Requested" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "image/png") { "png" }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/x-fortran") { "fortran" }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/javascript") { "js" }

    resp = get "/foo.f90", "HTTP_ACCEPT" => "text/javascript"
    resp.status.should == 200
    resp.body.should == "fortran"

    resp = get "/foo.f90", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200
    resp.body.should == "fortran"
  end

  feature "matches for absent extension if MimeTypes::Undefined is :requested" do
    Test::Resources::Map.on(:get,
                            ["foo"],
                            :requested => [Waves::Mime::Undefined, "text/html"]) {
      "undefined"
    }

    resp = get "/foo", {"HTTP_ACCEPT" => "text/javascript"}
    resp.status.should == 200
    resp.body.should == "undefined"
  end

  feature "follows normal first-match processing for Mime::Undefined" do
    Test::Resources::Map.on(:get, ["foo"], :requested => Waves::Mime::Undefined) { "undefined" }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/javascript") { "js" }

    resp = get "/foo", {"HTTP_ACCEPT" => "text/javascript"}
    resp.status.should == 200
    resp.body.should == "js"
  end

  feature "prefers absent extension over Requested, if Mime::Undefined is :requesteded" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/x-fortran") { "fortran" }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/javascript") { "js" }
    Test::Resources::Map.on(:get, ["foo"], :requested => Waves::Mime::Undefined) { "undefined" }

    resp = get "/foo", {"HTTP_ACCEPT" => "text/javascript"}
    resp.status.should == 200
    resp.body.should == "undefined"

    resp = get "/foo", {"HTTP_ACCEPT" => "text/x-fortran"}
    resp.status.should == 200
    resp.body.should == "undefined"
  end

  feature "does not match for absent extension by default" do
    Test::Resources::Map.on(:get,
                            ["foo"],
                            :requested => "text/html") {
      "undefined"
    }

    resp = get "/foo", {"HTTP_ACCEPT" => "text/javascript"}
    resp.status.should == 404
  end

  feature "matches single type Strings or Symbols against general MIME types" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "image") { }
    Test::Resources::Map.on(:get, ["bar"], :requested => :image) { }

    resp = get "/foo", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200

    resp = get "/bar", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200
  end

  feature "matches single type Strings or Symbols against MIME subtypes" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "png") { }
    Test::Resources::Map.on(:get, ["bar"], :requested => :png) { }

    resp = get "/foo", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200

    resp = get "/bar", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200
  end

  feature "matches type/* form MIME specifiers against general MIME types (but superfluous)" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "image/*") { }

    resp = get "/foo", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200

    resp = get "/foo", "HTTP_ACCEPT" => "image/jpeg"
    resp.status.should == 200
  end

  feature "does not match <type>/* form MIME specifiers against MIME subtypes" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "png/*") { }

    resp = get "/foo", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 404
  end

  feature "requested */* is not matched by anything" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "*/*") { }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/*") { }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/plain") { }

    resp = get "/foo", "HTTP_ACCEPT" => "*/*"
    resp.status.should == 404
  end

  feature "requested * is not matched by anything" do
    Test::Resources::Map.on(:get, ["foo"], :requested => "*") { }
    Test::Resources::Map.on(:get, ["foo"], :requested => "*/*") { }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/*") { }
    Test::Resources::Map.on(:get, ["foo"], :requested => "text/plain") { }

    resp = get "/foo", "HTTP_ACCEPT" => "*"
    resp.status.should == 404
  end

  feature "allows multiple MIMEs to be accepted for one representation" do
    Test::Resources::Map.on(:get,
                            ["foo"],
                            :requested => ["text/javascript",
                                        :application,
                                        "text/fortran",
                                        :png]) { }

    resp = get "/foo", "HTTP_ACCEPT" => "text/javascript"
    resp.status.should == 200

    resp = get "/foo", "HTTP_ACCEPT" => "text/fortran"
    resp.status.should == 200

    resp = get "/foo", "HTTP_ACCEPT" => "image/png"
    resp.status.should == 200

    resp = get "/foo", "HTTP_ACCEPT" => "application/xhtml+xml"
    resp.status.should == 200
  end

# feature handles FF, IE Opera Safari stupid Accept

end

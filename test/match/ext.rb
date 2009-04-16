require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'test/helpers.rb'

require 'waves/foundations/compact'
require "waves/runtime/mime_types"
require "waves/matchers/ext"

describe "File extension matching" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "returns falseish if single file extension Symbol is not matched" do
    m = Waves::Matchers::Ext.new :js

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false

    request = Waves::Request.new env("http://example.com/moo.sj",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end

  feature "returns falseish if none of Array of Symbol extensions match" do
    m = Waves::Matchers::Ext.new [:js, :html]

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false

    request = Waves::Request.new env("http://example.com/moo.sj",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end

  feature "returns trueish if single file extension Symbol does match" do
    m = Waves::Matchers::Ext.new :js

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    m.call(request).should == true
  end

  feature "returns trueish if any in Array of Symbol extensions match" do
    m = Waves::Matchers::Ext.new [:js, :html]

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == true

    request = Waves::Request.new env("http://example.com/moo.html",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == true
  end

  feature "fails to match a Symbol extension with a leading dot included" do
    m = Waves::Matchers::Ext.new :".js"

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end

  feature "matches absence of extension, returning true, if Array contains empty String" do
    m = Waves::Matchers::Ext.new [:js, :html, ""]

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == true
  end

  feature "fails to match if extension provided but no extension specified with empty String" do
    m = Waves::Matchers::Ext.new [""]

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end

  feature "empty String for absence of extension must be in an Array" do
    begin
      m = Waves::Matchers::Ext.new("")
      false
    rescue ArgumentError
      true
    end.should == true

    n = Waves::Matchers::Ext.new [""]
    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!n.call(request)).should == true
  end
end

describe "File extension matching in conjunction with Accept matching" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "fails if the Accept match fails" do
    m = Waves::Matchers::Request.new :accept => ["text/html"],
                                     :ext => :js

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end

  feature "matches if the extension is Accept-matched with or without Accept header" do
    m = Waves::Matchers::Request.new :accept => ["text/javascript"],
                                     :ext => :js

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == true

    request = Waves::Request.new env("http://example.com/moo.js", :method => "GET")

    (!!m.call(request)).should == true
  end

  feature "causes Accept match to fail if there is a file extension, and absence is specified" do
    m = Waves::Matchers::Request.new :accept => ["text/javascript"],
                                     :ext => [""]

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end

  feature "specifying extension is overridden by presence of Undefined in Accept" do
    m = Waves::Matchers::Request.new :accept => [Waves::Mime::Undefined],
                                     :ext => [:js]

    request = Waves::Request.new env("http://example.com/moo.js",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == false
  end
end


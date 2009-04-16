require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'test/helpers.rb'

require 'waves/foundations/compact'
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

  feature "matches absence of extension, returning true, if Array contains empty String" do
    m = Waves::Matchers::Ext.new [:js, :html, ""]

    request = Waves::Request.new env("http://example.com/moo",
                                     :method => "GET",
                                     "HTTP_ACCEPT" => "text/javascript")

    (!!m.call(request)).should == true
  end
end


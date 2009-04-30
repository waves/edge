require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
include Waves::Foundations

describe "A resource definition" do
  before :each do
    mock(File).exist?(%r{my_resources.resource_def_spec\.rb$}) { true }

    application(:ResourceDefApp) {
      composed_of {
        at ["defspec"], :ResourceDefSpec
        look_in "my_resources"
      }
    }

    module ResDefModule; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResDefModule
    Object.send :remove_const, :ResourceDefApp
    if Object.const_defined?(:ResourceDefSpec)
      Object.send :remove_const, :ResourceDefSpec
    end
  end

  it "takes a single Symbol argument for the resource name" do
    mock(ResourceDefApp).register(anything) { true }
    lambda { resource(:ResourceDefSpec) {} }.should_not raise_error
  end

  it "defines a class with given name as constant under its nesting" do
    ResDefModule.const_defined?(:ResourceDefSpec).should == false

    mock(ResourceDefApp).register(anything) { true }

    module ResDefModule
      resource(:ResourceDefSpec) {}
    end

    ResDefModule.const_defined?(:ResourceDefSpec).should == true
    ResDefModule::ResourceDefSpec.class.should == Class
  end

  it "defines a class with given name as constant if not nested" do
    Object.const_defined?(:ResourceDefSpec).should == false

    mock(ResourceDefApp).register(anything) { true }

    resource(:ResourceDefSpec) {}

    Object.const_defined?(:ResourceDefSpec).should == true
    ResourceDefSpec.class.should == Class
  end

  it "causes an entry to be created in the Application's resource table for itself" do
    path = File.expand_path(File.join(Dir.pwd, "my_resources", "resource_def_spec.rb"))
    ResourceDefApp.resources[path].should_not == nil

    mock(Kernel).load(anything) {
      resource(:ResourceDefSpec) { url_of_form [{:path => 0..-1}, :name] }
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    ResourceDefApp.resources[ResourceDefSpec].should_not == nil
    ResourceDefApp.resources[path].actual.should == ResourceDefSpec
  end

  it "includes the path information in the resource table entry" do
    path = File.expand_path(File.join(Dir.pwd, "my_resources", "resource_def_spec.rb"))

    mock(Kernel).load(anything) {
      resource(:ResourceDefSpec) { url_of_form [{:path => 0..-1}, :name] }
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    res = ResourceDefApp.resources[ResourceDefSpec]
    res.path.should == path
  end

  it "requires the resource to define the form of its URL" do
    stub(Kernel).load(anything) {
      lambda {
        resource(:ResourceDefSpec) { url_of_form [{:path => 0..-1}, :name] }
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "raises an error when defining 'methods' if the URL form has not been defined" do
    stub(Kernel).load(anything) {
      lambda {
        resource(:ResourceDefSpec) { viewable {} }
      }.should raise_error(REST::BadDefinition)
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "allows introducing new MIME types and their extensions" do
    mock(Kernel).load(anything) {
      resource :ResourceDefSpec do
        url_of_form [:hi]

        introduce_mime "vnd.hi.ho", :exts => ".hiho"
      end
    }

    Waves::MimeTypes[".hiho"].should == []

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves::MimeTypes[".hiho"].should == ["vnd.hi.ho"]
  end

  it "raises an error if no extensions are given for an introduced MIME type" do
    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceDefSpec do
          url_of_form [:hi]
          introduce_mime "vnd.ho.hi"
        end
      }.should raise_error(ArgumentError)
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "allows a MIME type to specify multiple extensions" do
    mock(Kernel).load(anything) {
      resource :ResourceDefSpec do
        url_of_form [:hi]

        introduce_mime "vnd.moo.mii", :exts => [".moomii", ".miimoo"]
      end
    }

    Waves::MimeTypes[".moomii"].should == []

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves::MimeTypes[".moomii"].should == ["vnd.moo.mii"]
    Waves::MimeTypes[".miimoo"].should == ["vnd.moo.mii"]
  end

  it "allows adding a MIME type multiple times" do
    mock(Kernel).load(anything) {
      resource :ResourceDefSpec do
        url_of_form [:hi]

        introduce_mime "vnd.a.b", :exts => ".aabi"
        introduce_mime "vnd.a.b", :exts => ".uubi"
      end
    }

    Waves::MimeTypes[".aabi"].should == []

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves::MimeTypes[".aabi"].should == ["vnd.a.b"]
    Waves::MimeTypes[".uubi"].should == ["vnd.a.b"]
  end

  it "ensures that the mappings only have a single instance of each extension" do
    mock(Kernel).load(anything) {
      resource :ResourceDefSpec do
        url_of_form [:hi]

        introduce_mime "vnd.b.a", :exts => ".beebi"
        introduce_mime "vnd.b.a", :exts => ".beebi"
      end
    }

    Waves::MimeTypes[".beebi"].should == []

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves::MimeTypes[".beebi"].should == ["vnd.b.a"]
  end

  it "adds the associated MimeExts inverse lookup when introducing MIME types" do
    mock(Kernel).load(anything) {
      resource :ResourceDefSpec do
        url_of_form [:hi]

        introduce_mime "vnd.weeblie", :exts => [".weeblex", ".beebliew"]
      end
    }

    Waves::MimeExts["vnd.weeblie"].should == []

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves::MimeExts["vnd.weeblie"].include?(".beebliew").should == true
    Waves::MimeExts["vnd.weeblie"].include?(".weeblex").should == true
  end

end


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

  it "exposes the URL form through .needed_from_url" do
    pathspec = [{:path => 0..-1}, :name]

    mock(Kernel).load(anything) {
      resource(:ResourceDefSpec) { url_of_form pathspec }
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/defspec", :method => "GET")
    Waves.main::Mounts.new(request).process

    ResourceDefSpec.needed_from_url.should == pathspec
  end
end


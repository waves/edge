require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

include Waves::Foundations

describe "Defining an Application" do

  after :each do
    Waves.applications.clear
    REST::Application.send :remove_const, :DefSpecApp if REST::Application.const_defined?(:DefSpecApp)
  end

  # @todo Much fleshing out here. Overrides and such. --rue

  it "requires a name" do
    lambda {
      application {}
    }.should raise_error

    lambda {
      application(:DefSpecApp) {}
    }.should_not raise_error
  end

  it "is created as named constant under REST::Application" do
    REST::Application.const_defined?(:DefSpecApp).should == false
    application(:DefSpecApp) {}
    REST::Application.const_defined?(:DefSpecApp).should == true
  end

  it "gives some full URL form when supplied a resource and its specifics" do
    res = Class.new(REST::Resource) {}

    ret = REST::Application.make_url_for res, [:whatever]
    ret.should include(:whatever)
  end

  it "provides a block to define the composition of resources" do
    lambda {
      application(:DefSpecApp) {
        composed_of {}
      }
    }.should_not raise_error
  end

  it "raises an error unless some resource composition is done" do
    fail
  end

  it "adds the Application to the application list" do
    Waves.applications.should be_empty

    myapp = nil
    application(:DefSpecApp) { myapp = self }

    Waves.applications.size.should == 1
    Waves.main.should == myapp
    Waves.main.name.split(/::/).last.should == "DefSpecApp"
  end
end


describe "Composing resources in the Application definition" do
  after :each do
    REST::Application.send :remove_const, :DefSpecApp if REST::Application.const_defined?(:DefSpecApp)
  end

  it "uses the .at method to map mount points to filenames, aliased to a constant" do
    application(:DefSpecApp) {
      composed_of {
        at ["foobar"], "page" => :Page
      }
    }

    resources = Waves.main.resources
    resources.size.should == 1
    resources[:Page].file.should == "page"
    resources[:Page].mountpoint.should == ["foobar"]
  end
end

describe "Currently active Application" do
  before :all do
    Object.send :remove_const, :DefSpec if Object.const_defined?(:DefSpec)
  end

  after :each do
    Object.send :remove_const, :DefSpec if Object.const_defined?(:DefSpec)
  end

  it "is not defined outside of an application definition block" do
    fail
  end

  it "is the application whose definition we are in" do
    fail
  end
end

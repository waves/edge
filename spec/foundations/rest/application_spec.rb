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

  it "is created as named constant under REST::Application using given name" do
    REST::Application.const_defined?(:DefSpecApp).should == false
    application(:DefSpecApp) {
      composed_of { at [true], "hi" => :Hi }
    }
    REST::Application.const_defined?(:DefSpecApp).should == true
  end

  it "gives some full URL form when supplied a resource and its specifics" do
    res = Class.new(REST::Resource) {}

    ret = REST::Application.make_url_for res, [:whatever]
    ret.should include(:whatever)
  end

  it "raises an error unless some resource composition is done" do
    lambda {
      application(:DefSpecApp) {
      }
    }.should raise_error

    lambda {
      application(:DefSpecApp) {
        composed_of {}
      }
    }.should raise_error
  end

  it "adds the Application to the application list" do
    Waves.applications.should be_empty

    myapp = nil
    application(:DefSpecApp) {
      myapp = self
      composed_of { at [true], "hi" => :Hi }
    }

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

  # @todo I am a bit iffy about the concept of a "main resource". --rue
  it "defines a Mounts resource as the root" do
    application(:DefSpecApp) {
      composed_of {
        at ["foobar"], "page" => :Page
      }
    }

    REST::Application::DefSpecApp::Mounts.const_defined?(:Mounts).should == true
  end

end


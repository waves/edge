require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
include Waves::Foundations

describe "A resource definition" do
  before :all do
    application(:DefApp) {
      composed_of {
        at ["defspec"], "somefile" => :DefSpec
      }
    }

    module ResDefModule; end
  end

  after :all do
    Waves.applications.clear
    Object.send :remove_const, :ResDefModule
    Object.send :remove_const, :DefApp
  end

  after :each do
    if Object.const_defined?(:DefSpec)
      Object.send :remove_const, :DefSpec
    end
  end

  it "takes a single Symbol argument for the resource name" do
    lambda { resource(:DefSpec) {} }.should_not raise_error
  end

  it "defines a class with given name as constant under its nesting" do
    ResDefModule.const_defined?(:DefSpec).should == false

    module ResDefModule
      resource(:DefSpec) {}
    end

    ResDefModule.const_defined?(:DefSpec).should == true
    ResDefModule::DefSpec.class.should == Class
  end

  it "defines a class with given name as constant if not nested" do
    Object.const_defined?(:DefSpec).should == false

    resource(:DefSpec) {}

    Object.const_defined?(:DefSpec).should == true
    DefSpec.class.should == Class
  end

  # @todo This is kind of annoying to have explicit but not
  #       automatically present in the def. --rue
  #
  # @todo Maybe try to use #/ for defining the URLs for
  #       extra fun.
  it "requires the resource to define the form of its URL" do
    lambda {
      resource(:DefSpec) { url_of_form [{:path => 0..-1}, :name] }
    }.should_not raise_error
  end

  it "raises an error when defining 'methods' if the URL form has not been defined" do
    lambda {
      resource(:DefSpec) { viewable {} }
    }.should raise_error(REST::BadDefinition)
  end

end


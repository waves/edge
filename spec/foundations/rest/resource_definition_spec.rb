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
  end

  after :all do
    REST::Application.send :remove_const, :DefApp
  end

  after :each do
    if REST::Application::DefApp.const_defined?(:DefSpec)
      REST::Application::DefApp.send :remove_const, :DefSpec
    end
  end

  it "takes a single Symbol argument for the resource name" do
    lambda { resource(:DefSpec) {} }.should_not raise_error
  end

  it "defines a class using the given name under the active App" do
    REST::Application::DefApp.const_defined?(:DefSpec).should == false

    resource(:DefSpec) {}

    REST::Application::DefApp.const_defined?(:DefSpec).should == true
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
    }.should raise_error

    lambda {
      resource(:DefSpec) { creatable {} }
    }.should raise_error
  end

end


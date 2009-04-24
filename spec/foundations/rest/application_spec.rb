require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

include Waves::Foundations

describe "The Application" do

  after :each do
    REST::Application.send :remove_const, :MyApp if REST::Application.const_defined?(:MyApp)
  end

  # @todo Much fleshing out here. Overrides and such. --rue

  it "requires a name" do
    lambda {
      application {}
    }.should raise_error

    lambda {
      application(:MyApp) {}
    }.should_not raise_error
  end

  it "is created as named constant under REST::Application" do
    REST::Application.const_defined?(:MyApp).should == false
    application(:MyApp) {}
    REST::Application.const_defined?(:MyApp).should == true
  end

  it "gives some full URL form when supplied a resource and its specifics" do
    res = Class.new(REST::Resource) {}

    ret = REST::Application.make_url_for res, [:whatever]
    ret.should include(:whatever)
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

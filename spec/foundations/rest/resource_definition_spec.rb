require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

describe "A resource definition" do
  before :all do
    Object.send :remove_const, :DefSpec if Object.const_defined?(:DefSpec)
  end

  after :each do
    Object.send :remove_const, :DefSpec if Object.const_defined?(:DefSpec)
  end

  it "takes a single Symbol argument for the resource name" do
    lambda { resource(:DefSpec) {} }.should_not raise_error
  end

  it "defines a class using the given name" do
    Object.const_defined?(:DefSpec).should == false

    resource(:DefSpec) {}

    Object.const_defined?(:DefSpec).should == true
    DefSpec.class.should == Class
  end
end

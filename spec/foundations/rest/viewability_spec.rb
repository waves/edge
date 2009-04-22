require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

describe "Viewability definition for a resource" do
  before :all do
    Object.send :remove_const, :ViewSpec if Object.const_defined?(:ViewSpec)
  end

  after :each do
    Object.send :remove_const, :ViewSpec if Object.const_defined?(:ViewSpec)
  end

  it "is available through the method #viewable in a resource definition" do
    lambda {
      resource :ViewSpec do
        viewable {}
      end
    }.should_not raise_error
  end
end

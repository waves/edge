require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

include Waves::Foundations

describe "The Application" do
  before :all do
    Object.send :remove_const, :DefSpec if Object.const_defined?(:DefSpec)
  end

  after :each do
    Object.send :remove_const, :DefSpec if Object.const_defined?(:DefSpec)
  end

  # @todo Much fleshing out here. Overrides and such. --rue

  it "gives some full URL form when supplied a resource and its specifics" do
    res = Class.new(REST::Resource) {}

    ret = REST::Application.make_url_for res, [:whatever]
    ret.should include(:whatever)
  end

end

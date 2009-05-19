require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
require "waves/matchers/request"

include Waves::Foundations

# @todo Redefine to use content rather than Requested.

describe "Createability definition for a resource" do
  before :each do
    mock(File).exist?(%r{resources.resource_create_spec\.rb$}) { true }

    application(:ResourceCreateApp) {
      composed_of {
        at ["createspec"], :ResourceCreateSpec
        look_in "resources"
      }
    }

    module ResourceCreateSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResourceCreateSpec if Object.const_defined?(:ResourceCreateSpec)
    Object.send :remove_const, :ResourceCreateSpecMod
    Object.send :remove_const, :ResourceCreateApp
  end

  it "is available through the method #creatable in a resource definition" do
    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceCreateSpec do
          url_of_form [:hi]
          creatable {}
        end
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/createspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end
end

describe "Matcher created by a creatable definition" do
  before :each do
    mock(File).exist?(%r{resources.resource_create_spec\.rb$}) { true }

    application(:ResourceCreateApp) {
      composed_of {
        at ["createspec"], :ResourceCreateSpec
        look_in "resources"
      }
    }

    module ResourceCreateSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResourceCreateSpec if Object.const_defined?(:ResourceCreateSpec)
    Object.send :remove_const, :ResourceCreateSpecMod
    Object.send :remove_const, :ResourceCreateApp
  end

  it "will match on POST requests" do
    mock(REST::Resource).on(:post, anything, anything)

    mock(Kernel).load(anything) {
      resource :ResourceCreateSpec do
        url_of_form [{:path => 0..-1}, :name]

        creatable {
          representation("text/javascript") {}
        }
      end
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/createspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "looks for the given requested type(s)" do
    mock(REST::Resource).on(:post, anything, hash_including(:requested => ["text/javascript"]))

    mock(Kernel).load(anything) {
      resource :ResourceCreateSpec do
        url_of_form [{:path => 0..-1}, :name]

        creatable {
          representation("text/javascript") {}
        }
      end
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/createspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "is defined for the path constructed by .url_of_form" do
    pathspec = ["createspec", {:path => 0..-1}, :name]

    mock(REST::Resource).on(:post, pathspec, anything)

    mock(Kernel).load(anything) {
      resource :ResourceCreateSpec do
        url_of_form [{:path => 0..-1}, :name]

        creatable {
          representation("text/javascript") {}
        }
      end
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/createspec", :method => "GET")
    Waves.main::Mounts.new(request).process

  end

end

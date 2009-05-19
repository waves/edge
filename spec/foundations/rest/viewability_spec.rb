require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
require "waves/matchers/request"

include Waves::Foundations

describe "Viewability definition for a resource" do
  before :each do
    mock(File).exist?(%r{resources.resource_view_spec\.rb$}) { true }

    application(:ResourceViewApp) {
      composed_of {
        at ["vjuuspec"], :ResourceViewSpec
        look_in "resources"
      }
    }

    module ResourceViewSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
    Object.send :remove_const, :ResourceViewSpecMod
    Object.send :remove_const, :ResourceViewApp
  end

  it "is available through the method #viewable in a resource definition" do
    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceViewSpec do
          url_of_form [:hi]
          viewable {}
        end
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end
end

describe "The set of representations supported by a resource" do
  before :each do
    mock(File).exist?(%r{resources.resource_view_spec\.rb$}) { true }

    application(:ResourceViewApp) {
      composed_of {
        at ["vjuuspec"], :ResourceViewSpec
        look_in "resources"
      }
    }

    module ResourceViewSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
    Object.send :remove_const, :ResourceViewSpecMod
    Object.send :remove_const, :ResourceViewApp
  end

  it "is defined through the #representation method inside a #viewable block" do
    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceViewSpec do
          url_of_form [:hi]
          viewable {
            representation {}
          }
        end
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end
end

describe "A representation definition" do
  before :each do
    mock(File).exist?(%r{resources.resource_view_spec\.rb$}) { true }

    application(:ResourceViewApp) {
      composed_of {
        at ["vjuuspec"], :ResourceViewSpec
        look_in "resources"
      }
    }

    module ResourceViewSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
    Object.send :remove_const, :ResourceViewSpecMod
    Object.send :remove_const, :ResourceViewApp
  end

  it "takes the MIME type the representation is for" do
    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceViewSpec do
          url_of_form [:hi]
          viewable {
            representation("text/html") {}
          }
        end
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "allows more than one MIME type to be specified" do
    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceViewSpec do
          url_of_form [:hi]
          viewable {
            representation("text/html", "application/xhtml+xml") {}
          }
        end
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "defines a matcher" do
    mock(Waves::Matchers::Request).new(anything).times(2)

    mock(Kernel).load(anything) {
      lambda {
        resource :ResourceViewSpec do
          url_of_form [:hi]
          viewable {
            representation("text/javascript") {}
          }
        end
      }.should_not raise_error
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end
end

# @todo This is somewhat unscientific. --rue
describe "Matcher created by a viewable definition" do
  before :each do
    mock(File).exist?(%r{resources.resource_view_spec\.rb$}) { true }

    application(:ResourceViewApp) {
      composed_of {
        at ["vjuuspec"], :ResourceViewSpec
        look_in "resources"
      }
    }

    module ResourceViewSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
    Object.send :remove_const, :ResourceViewSpecMod
    Object.send :remove_const, :ResourceViewApp
  end

  it "will match on GET requests" do
    mock(REST::Resource).on(:get, anything, anything)

    mock(Kernel).load(anything) {
      resource :ResourceViewSpec do
        url_of_form [{:path => 0..-1}, :name]
          viewable {
            representation("text/javascript") {}
          }
      end
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "looks for the given requested type(s)" do
    mock(REST::Resource).on(:get, anything, hash_including(:requested => ["text/javascript"]))

    mock(Kernel).load(anything) {
      resource :ResourceViewSpec do
        url_of_form [{:path => 0..-1}, :name]
          viewable {
            representation("text/javascript") {}
          }
      end
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "is defined for the path constructed by .url_of_form" do
    pathspec = ["vjuuspec", {:path => 0..-1}, :name]

    mock(REST::Resource).on(:get, pathspec, anything)

    mock(Kernel).load(anything) {
      resource :ResourceViewSpec do
        url_of_form [{:path => 0..-1}, :name]
          viewable {
            representation("text/javascript") {}
          }
      end
      true
    }

    stub.instance_of(Waves.main::Mounts).to { true }

    request = Waves::Request.new env("http://example.com/vjuuspec", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

end

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
require "waves/matchers/request"

include Waves::Foundations

describe "Viewability definition for a resource" do
  before :all do
    application(:ResourceViewApp) {
      composed_of {
        at ["createspec"], "somefile" => :ResourceViewSpec
      }
    }
  end

  after :all do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewApp
  end

  after :each do
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
  end

  it "is available through the method #viewable in a resource definition" do
    lambda {
      resource :ResourceViewSpec do
        url_of_form [:hi]

        viewable {}
      end
    }.should_not raise_error
  end
end

describe "The set of representations supported by a resource" do
  before :all do
    application(:ResourceViewApp) {
      composed_of {
        at ["createspec"], "somefile" => :ResourceViewSpec
      }
    }
  end

  after :all do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewApp
  end

  after :each do
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
  end

  it "is defined through the #representation method inside a #viewable block" do
    lambda {
      resource :ResourceViewSpec do
        url_of_form [:hi]

        viewable {
          representation {}
        }
      end
    }.should_not raise_error
  end
end

describe "A representation definition" do
  before :all do
    application(:ResourceViewApp) {
      composed_of {
        at ["createspec"], "somefile" => :ResourceViewSpec
      }
    }
  end

  after :all do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewApp
  end

  after :each do
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
  end

  it "takes the MIME type the representation is for" do
    lambda {
      resource :ResourceViewSpec do
        url_of_form [:hi]

        viewable {
          representation("text/html") {}
        }
      end
    }.should_not raise_error
  end

  it "allows more than one MIME type to be specified" do
    lambda {
      resource :ResourceViewSpec do
        url_of_form [:hi]

        viewable {
          representation("text/html", "application/xml+xhtml") {}
        }
      end
    }.should_not raise_error
  end

  it "defines a matcher" do
    mock(Waves::Matchers::Request).new(anything)

    resource :ResourceViewSpec do
      url_of_form [:hi]

      viewable {
        representation("text/javascript") {}
      }
    end
  end
end

# @todo This is somewhat unscientific. --rue
describe "Matcher created by a viewable definition" do
  before :all do
    application(:ResourceViewApp) {
      composed_of {
        at ["viewspec"], "somefile" => :ResourceViewSpec
      }
    }
  end

  after :all do
    Waves.applications.clear
    Object.send :remove_const, :ResourceViewApp
  end

  after :each do
    Object.send :remove_const, :ResourceViewSpec if Object.const_defined?(:ResourceViewSpec)
  end

  it "will match on GET requests" do
    mock(REST::Resource).on(:get, anything, anything)

    resource :ResourceViewSpec do
      url_of_form [{:path => 0..-1}, :name]

      viewable {
        representation("text/javascript") {}
      }
    end
  end

  it "looks for the given requested type(s)" do
    mock(REST::Resource).on(:get, anything, hash_including(:requested => ["text/javascript"]))

    resource :ResourceViewSpec do
      url_of_form [{:path => 0..-1}, :name]

      viewable {
        representation("text/javascript") {}
      }
    end
  end

  it "is defined for the path constructed by .url_of_form" do
    pathspec = ["viewspec", {:path => 0..-1}, :name]

    mock(REST::Resource).on(:get, pathspec, anything)

    resource :ResourceViewSpec do
      url_of_form [{:path => 0..-1}, :name]

      viewable {
        representation("text/javascript") {}
      }
    end
  end

end

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
require "waves/matchers/request"

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
        url_of_form :hi

        viewable {}
      end
    }.should_not raise_error
  end
end

describe "The set of representations supported by a resource" do
  before :all do
    Object.send :remove_const, :ViewSpec if Object.const_defined?(:ViewSpec)
  end

  after :each do
    Object.send :remove_const, :ViewSpec if Object.const_defined?(:ViewSpec)
  end

  it "is defined through the #representation method inside a #viewable block" do
    lambda {
      resource :ViewSpec do
        url_of_form :hi

        viewable {
          representation {}
        }
      end
    }.should_not raise_error
  end
end

describe "A representation definition" do
  before :all do
    Object.send :remove_const, :ViewSpec if Object.const_defined?(:ViewSpec)
  end

  after :each do
    Object.send :remove_const, :ViewSpec if Object.const_defined?(:ViewSpec)
  end

  it "takes the MIME type the representation is for" do
    lambda {
      resource :ViewSpec do
        url_of_form :hi

        viewable {
          representation("text/html") {}
        }
      end
    }.should_not raise_error
  end

  it "allows more than one MIME type to be specified" do
    lambda {
      resource :ViewSpec do
        url_of_form :hi

        viewable {
          representation("text/html", "application/xml+xhtml") {}
        }
      end
    }.should_not raise_error
  end

  it "defines a matcher for the specified type" do
    # @todo This is somewhat unscientific. --rue
    mock(Waves::Matchers::Request).new(hash_including(:request => %w[text/javascript]))

    resource :ViewSpec do
      url_of_form :hi

      viewable {
        representation("text/javascript") {}
      }
    end
  end

end

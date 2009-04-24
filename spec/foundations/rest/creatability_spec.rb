require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"
require "waves/matchers/request"

include Waves::Foundations

# @todo Redefine to use content rather than Requested.

describe "Createability definition for a resource" do
  before :all do
    application(:ResourceCreateApp) {
      composed_of {
        at ["createspec"], "somefile" => :ResourceCreateSpec
      }
    }
  end

  after :all do
    Waves.applications.clear
    REST::Application.send :remove_const, :ResourceCreateApp
  end

  after :each do
    if REST::Application::ResourceCreateApp.const_defined?(:ResourceCreateSpec)
      REST::Application::ResourceCreateApp.send :remove_const, :ResourceCreateSpec
    end
  end

  it "is available through the method #viewable in a resource definition" do
    lambda {
      resource :ResourceCreateSpec do
        url_of_form :hi

        creatable {}
      end
    }.should_not raise_error
  end
end

describe "Matcher created by a viewable definition" do
  before :all do
    application(:ResourceCreateApp) {
      composed_of {
        at ["createspec"], "somefile" => :ResourceCreateSpec
      }
    }
  end

  after :all do
    Waves.applications.clear
    REST::Application.send :remove_const, :ResourceCreateApp
  end

  after :each do
    if REST::Application::ResourceCreateApp.const_defined?(:ResourceCreateSpec)
      REST::Application::ResourceCreateApp.send :remove_const, :ResourceCreateSpec
    end
  end

  it "will match on POST requests" do
    mock(REST::Resource).on(:post, anything, anything)

    resource :ResourceCreateSpec do
      url_of_form [{:path => 0..-1}, :name]

      creatable {
        representation("text/javascript") {}
      }
    end
  end

  it "looks for the given requested type(s)" do
    mock(REST::Resource).on(:post, anything, hash_including(:requested => ["text/javascript"]))

    resource :ResourceCreateSpec do
      url_of_form [{:path => 0..-1}, :name]

      creatable {
        representation("text/javascript") {}
      }
    end
  end

  it "is defined for the path constructed by .url_of_form" do
    pathspec = ["prefeex", {:path => 0..-1}, :name]

    mock(REST::Application).make_url_for(anything, [{:path => 0..-1}, :name]) {
      pathspec
    }

    mock(REST::Resource).on(:post, pathspec, anything)

    resource :ResourceCreateSpec do
      url_of_form [{:path => 0..-1}, :name]

      creatable {
        representation("text/javascript") {}
      }
    end
  end

end

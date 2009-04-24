require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

include Waves::Foundations

describe "Defining an Application" do

  after :each do
    Waves.applications.clear
    REST::Application.send :remove_const, :DefSpecApp if REST::Application.const_defined?(:DefSpecApp)
  end

  # @todo Much fleshing out here. Overrides and such. --rue

  it "is created as named constant under REST::Application using given name" do
    REST::Application.const_defined?(:DefSpecApp).should == false
    application(:DefSpecApp) {
      composed_of { at [true], "hi" => :Hi }
    }
    REST::Application.const_defined?(:DefSpecApp).should == true
  end

  it "raises an error unless some resource composition is done" do
    lambda {
      application(:DefSpecApp) {
      }
    }.should raise_error(REST::BadDefinition)

    lambda {
      application(:DefSpecApp) {
        composed_of {}
      }
    }.should raise_error(REST::BadDefinition)
  end

  it "adds the Application to the application list" do
    Waves.applications.should be_empty

    myapp = nil
    application(:DefSpecApp) {
      myapp = self
      composed_of { at [true], "hi" => :Hi }
    }

    Waves.applications.size.should == 1
    Waves.main.should == myapp
    Waves.main.name.split(/::/).last.should == "DefSpecApp"
  end
end


describe "Composing resources in the Application definition" do
  after :each do
    Waves.applications.clear
    REST::Application.send :remove_const, :DefSpecApp if REST::Application.const_defined?(:DefSpecApp)
  end

  it "uses the .at method to map mount points to filenames, aliased to a name" do
    application(:DefSpecApp) {
      composed_of {
        at ["foobar"], "page" => :page
      }
    }

    resources = Waves.main.resources
    resources.size.should == 1
    resources[:page].file.should == "page"
    resources[:page].mountpoint.should == ["foobar"]
  end

  it "stores the name as a lowercase symbol" do
    application(:DefSpecApp) {
      composed_of {
        at ["foobar2"], "page2" => :Page
      }
    }

    resources = Waves.main.resources
    resources[:page].file.should == "page2"
    resources[:page].mountpoint.should == ["foobar2"]
  end

  # @todo I am a bit iffy about the concept of a "main resource". --rue
  it "defines a Mounts resource as the root" do
    application(:DefSpecApp) {
      composed_of {
        at ["foobar"], "page" => :Page
      }
    }

    REST::Application::DefSpecApp.const_defined?(:Mounts).should == true
  end

  # @todo This needs a functional counterpart to actually verify the call. --rue
  it "defines matchers for a composing resource using its mount point" do
    mock(Waves::Resources::Base).on(true, ["foobar"])

    application(:DefSpecApp) {
      composed_of {
        at ["foobar"], "pg" => :Page
      }
    }
  end

  # @todo Do we need to assert the negative here too? --rue
  it "defines matchers for all composing resources in order of appearance" do
    sequence = [["foobar"],
                [true],
                ["meebies"],
                [],
                ["ugga"]
               ]

    mock(Waves::Resources::Base).on(true,
                                    satisfy {|path|
                                      path == sequence.shift
                                    }
                                   ).times(sequence.size)

    application(:DefSpecApp) {
      composed_of {
        at ["foobar"], "pg" => :Page
        at [true], "me" => :whatever
        at ["meebies"], "bleh" => "yay"
        at [], "weird" => :evenStranger
        at ["ugga"], "meh/beh" => :Alt
      }
    }
  end
end


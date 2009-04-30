require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper.rb"))

# Our stuff
require "waves/runtime/mime_types"

describe "MIME type mapping" do
  # @todo Needs some heavy improvement.. --rue
  it "provides a mapping from extensions to MIME types" do
    Waves.const_defined?(:MimeTypes).should == true
    Waves::MimeTypes[".txt"].should == ["text/plain"]
  end

  it "makes a reverse mapping of MimeTypes available as MimeExts" do
    Waves::MimeTypes.each {|key, values|
      values.each {|value|
        Waves::MimeExts[value].include?(key).should == true
      }
    }
  end

  it "defines an 'unspecified' MIME type" do
    Waves::Mime::Unspecified.should be_kind_of(String)
  end
end


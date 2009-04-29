require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb"))

# Our stuff
require "waves/foundations/rest"

include Waves::Foundations

describe "Defining an Application" do
  before :all do
    module AppDefModule; end
  end

  after :all do
    Object.send :remove_const, :AppDefModule
  end

  after :each do
    Waves.applications.clear
    AppDefModule.send :remove_const, :AppDefSpec if AppDefModule.const_defined?(:AppDefSpec)
    Object.send :remove_const, :AppDefSpec if Object.const_defined?(:AppDefSpec)
  end

  it "is created as a class by given name under the nesting module" do
    AppDefModule.const_defined?(:AppDefSpec).should == false

    mock(File).exist?(anything) { true }

    module AppDefModule
      application(:AppDefSpec) {
        composed_of { at [true], "hi" }
      }
    end

    AppDefModule.const_defined?(:AppDefSpec).should == true
    Object.const_defined?(:AppDefSpec).should == false
  end

  it "is created as a class by given name under Object if not nested" do
    Object.const_defined?(:AppDefSpec).should == false

    mock(File).exist?(anything) { true }

    application(:AppDefSpec) {
      composed_of { at [true], "hi" }
    }

    Object.const_defined?(:AppDefSpec).should == true
  end

  it "raises an error unless some resource composition is done" do
    lambda {
      application(:AppDefSpec) {
      }
    }.should raise_error(REST::BadDefinition)

    lambda {
      application(:AppDefSpec) {
        composed_of {}
      }
    }.should raise_error(REST::BadDefinition)
  end

  it "adds the Application to the application list" do
    Waves.applications.should be_empty

    mock(File).exist?(anything) { true }

    myapp = Object.new
    application(:AppDefSpec) {
      myapp = self
      composed_of { at [true], "hi" }
    }

    Waves.applications.size.should == 1
    Waves.main.should == myapp
  end
end


describe "Composing resources in the Application definition" do
  after :each do
    Waves.applications.clear
    Object.send :remove_const, :AppDefSpec if Object.const_defined?(:AppDefSpec)
  end

  it "uses the .at method to map mount points to file paths for resource implementation" do
    mock(File).exist?(satisfy {|f| f =~ %r{resources.at_first\.rb$} }) { true }

    lambda {
      application(:AppDefSpec) {
        composed_of {
          at ["mount1"], "resources/at_first.rb"
        }
      }
    }.should_not raise_error
  end

  it "raises an error if a path given to .at is invalid" do
    mock(File).exist?(satisfy {|f| f =~ %r{resources.at_second\.rb$} }) { false }

    lambda {
      application(:AppDefSpec) {
        composed_of {
          at ["mount2"], "resources/at_second.rb"
        }
      }
    }.should raise_error(ArgumentError)
  end

  it "accepts single Symbols given as 'paths', just #to_s, #snake_case + '.rb' " do
    mock(File).exist?(satisfy {|f| f =~ %r{symbolic_file\.rb$} }) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["mount10"], :SymbolicFile
      }
    }
  end

  it "allows a path prefix for .at paths to be given to .look_in" do
    mock(File).exist?(satisfy {|f| f =~ %r{prefix/rest\.rb$} }) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["lookie1"], :Rest

        look_in "prefix"
      }
    }
  end

  it "allows a path prefix for .at paths to either include trailing / or not" do
    mock(File).exist?(satisfy {|f| f =~ %r{prefix_two/rest_two\.rb$} }) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["lookie2"], :RestTwo

        look_in "prefix_two/"
      }
    }
  end

  it "checks more than one .look_in prefixes each in turn, using first found" do
    mock(File) do |file|
      file.exist?(satisfy {|f| f =~ %r{prefix_0/rest_three\.rb$}}) { false }
      file.exist?(satisfy {|f| f =~ %r{prefix_2/rest_three\.rb$}}) { false }
      file.exist?(satisfy {|f| f =~ %r{prefix_1/rest_three\.rb$}}) { true }
    end

    application(:AppDefSpec) {
      composed_of {
        at ["lookie3"], :RestThree

        look_in "prefix_0/", "prefix_2", "prefix_1/"
      }
    }
  end

  it "defines a Mounts resource as the root" do
    mock(File).exist?(anything) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["mount5"], "mounts_one.rb"
      }
    }

    AppDefSpec.const_defined?(:Mounts).should == true
  end

  it "defines matchers for a composing resource using its mount point" do
    mock(File).exist?(anything) { true }
    mock(Waves::Resources::Base).on(true, ["mount6"])

    application(:AppDefSpec) {
      composed_of {
        at ["mount6"], "mounts_two.rb"
      }
    }
  end

  # @todo Do we need to assert the negative here too? --rue
  it "defines matchers for all composing resources in order of appearance" do
    mock(File).exist?(anything).times(5) { true }

    sequence = [["mount7"],
                [true],
                ["mount8"],
                [],
                ["mount9"]
               ]

    mock(Waves::Resources::Base).on(true,
                                    satisfy {|path|
                                      path == sequence.shift
                                    }
                                   ).times(sequence.size)

    application(:AppDefSpec) {
      composed_of {
        at ["mount7"],  "matchies_one.rb"
        at [true],      "matchies_two.rb"
        at ["mount8"],  "matchies_three.rb"
        at [],          "matchies_four.rb"
        at ["mount9"],  "matchies_five.rb"
      }
    }
  end

  it "stores the file paths given in .at as keys of .resources" do
    mock(File).exist?(satisfy {|f| f =~ %r{resources/at_fourth\.rb$} }) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["mount4"], "resources/at_fourth.rb"
      }
    }

    full = File.expand_path "resources/at_fourth.rb"

    res = Waves.main.resources[full]
    res.mountpoint.should == ["mount4"]
  end

  it "sets the file(s) from .at to load when the mountpoint is hit" do
    mock(File).exist?(satisfy {|f| f =~ %r{resources/at_third\.rb$} }) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["mount3"], "resources/at_third.rb"
      }
    }

    full = File.expand_path "resources/at_third.rb"

    mock(Kernel).load(full) { true }

    request = Waves::Request.new env("http://example.com/mount3", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "sets the file being loaded as the .loading file for the Application when loading it" do
    mock(File).exist?(%r{app_first_resource_load_a\.rb$}) { true }
    mock(File).exist?(%r{app_first_resource_load_b\.rb$}) { true }

    a = File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "app_first_resource_load_a.rb"))
    b = File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "app_first_resource_load_b.rb"))

    application(:AppDefSpec) {
      composed_of {
        at ["first_load_one"], :AppFirstResourceLoadA
        at ["first_load_two"], :AppFirstResourceLoadB
        look_in File.dirname(a)
      }
    }

    Waves.main.loading.should == nil

    request = Waves::Request.new env("http://example.com/first_load_two", :method => "GET")
    Waves.main::Mounts.new(request).process

    $app_first_resource_loading.should == b
    Waves.main.loading.should == nil

    request = Waves::Request.new env("http://example.com/first_load_one", :method => "GET")
    Waves.main::Mounts.new(request).process

    $app_first_resource_loading.should == a
    Waves.main.loading.should == nil
  end
end

describe "An Application designated to be composed of a given resource" do
  before :each do
    mock(File).exist?(anything) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["composee", :something], "composee.rb"
        look_in "resources"
      }
    }

    @fullpath = File.expand_path(File.join(Dir.pwd, "resources", "composee.rb"))
    module AppDefSpecMod; end
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :AppDefSpecMod if Object.const_defined?(:AppDefSpecMod)
    Object.send :remove_const, :AppDefSpec if Object.const_defined?(:AppDefSpec)
  end

  it "allows the resource to register itself when it loads" do
    mock(Kernel).load(anything) {
      module AppDefSpecMod
        resource(:Moomin) { }
      end
      true
    }

    mock(AppDefSpec).register(satisfy {|res|
      (REST::Resource > res) && res.name == "AppDefSpecMod::Moomin"
    })

    request = Waves::Request.new env("http://example.com/composee/hi", :method => "GET")
    Waves.main::Mounts.new(request).process
  end

  it "adds the resource in the path entry in the resource table" do
    mock(Kernel).load(@fullpath) {
      module AppDefSpecMod
        resource(:Meebie) { }
      end
      true
    }

    request = Waves::Request.new env("http://example.com/composee/hi", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves.main.resources[@fullpath].actual.should == AppDefSpecMod::Meebie
  end

  it "creates an entry for the resource itself with the info from resources" do
    mock(Kernel).load(@fullpath) {
      module AppDefSpecMod
        resource(:Uggabugga) { }
      end
      true
    }

    request = Waves::Request.new env("http://example.com/composee/hi", :method => "GET")
    Waves.main::Mounts.new(request).process

    Waves.main.resources[@fullpath].actual.should == AppDefSpecMod::Uggabugga
    res = Waves.main.resources[AppDefSpecMod::Uggabugga]
    res.path.should == @fullpath
    res.mountpoint.should == Waves.main.resources[@fullpath].mountpoint
  end
end

describe "An Application supporting a resource" do
  before :each do
    mock(File).exist?(anything) { true }

    application(:AppDefSpec) {
      composed_of {
        at ["support", :something], "resources/supporter_one.rb"
      }
    }
  end

  after :each do
    Waves.applications.clear
    Object.send :remove_const, :AppDefSpec if Object.const_defined?(:AppDefSpec)
  end

  # @todo Dunno if this applies at all anymore, probably better
  #       in registration, but the principle is the same. --rue
  it "provides it a full pathspec given the resource-specific part using .url_for" do
    mock(fake = Object.new) do
      defined_in() { File.expand_path "resources/supporter_one.rb" }
      needed_from_url() { [{:path => 0..-1}, :name] }
    end

    pathspec = Waves.main.url_for fake
    pathspec.should == ["support", :something, {:path => 0..-1}, :name]
  end
end


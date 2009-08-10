module Waves
  module Layers
    module MVC

      def self.included( app )
        
        require 'waves/layers/mvc/extensions'
        require 'waves/layers/mvc/controllers'
        require 'hoshi'
        require 'waves/helpers/basic'
        require 'waves/helpers/formatting'
        require 'waves/helpers/form'
        
        app.auto_create_module( :Models ) do
          auto_create_class :Default
          auto_load :Default, :directories => [ :models ]
          auto_create_class true, :Default
          auto_load true, :directories => [ :models ]
        end

        app.auto_create_module( :Views ) do
          auto_create_class :Default, Hoshi::View[:html4_transitional] do
            include Waves::Views::Mixin
            include Waves::Helpers::Basic
            include Waves::Helpers::Formatting
            include Waves::Helpers::Form
          end
          auto_create_class :Templated do
            include Waves::Views::Mixin
            include Waves::Views::Templated
          end
          auto_load :Default, :directories => [ :views ]
          auto_create_class true, :Default
          auto_load true, :directories => [ :views ]
        end

        app.auto_create_module( :Controllers ) do
          auto_create_class :Default, Waves::Controllers::Base
          auto_load :Default, :directories => [ :controllers ]
          auto_create_class true, :Default
          auto_load true, :directories => [ :controllers ]          
        end

        #
        # We autoload helpers and so forth to emulate Rails technique
        # of having an application-level helper (Default) and then one
        # per view class. However, we only use this with templated views
        # (since mixing in a helper module is sometimes a bit tricky).
        # "Native" Waves views (aka Hoshi) are ordinary classes so they
        # don't really need this, but you can always just include a class
        # level helper and it will automatically pick up your defaults
        # if it is not explicitly defined.
        #
        
        app.auto_create_module( :Helpers ) do
          auto_create_module( :Default )
          auto_load :Default, :directories => [ :helpers ]
          auto_create_module( true ) { include app::Helpers::Default }
          auto_load true, :directories => [ :helpers ]
        end
        
      end
    end
  end
end

module Waves
  module Foundations
    
    # Provides Sun MVC features for your application.
    # Includes ERb-style templates. You can also include others via Renderer Layers.
    # It does NOT include a default ORM. Use an ORM Layer for that.
    
    module Classic

      def self.included( app )

        gem 'dyoder-autocode', '~> 1.0.1'
        require 'autocode'

        require 'waves/layers/mvc'
        require 'waves/layers/text/inflect/english'
        require 'waves/layers/text/helpers'
        require 'waves/helpers/extended'
        
        app.module_eval do

          include AutoCode
          
          app.auto_create_module( :Configurations ) do
            auto_create_class :Default, Waves::Configurations::Default
            auto_load :Default, :directories => [ :configurations ]
            auto_create_class true, :Default
            auto_load true, :directories => [ :configurations ]
          end

          app.auto_create_module( :Resources ) do
            auto_create_class :Default, Waves::Resources::Base
            auto_load :Default, :directories => [ :resources ]
            auto_create_class true, :Default
            auto_load true, :directories => [ :resources ]
            auto_eval :Map do
              handler( Waves::Dispatchers::NotFoundError ) do
                request.response.content_type = 'text/html'
                app::Views::Error.new( request ).not_found_404
              end
            end
          end

          include Waves::Layers::Text::Inflect::English
          include Waves::Layers::Text::Helpers
          include Waves::Layers::MVC
          include Waves::Renderers::Erubis   
          include Waves::Renderers::Markaby   
          
        end
        
        Waves << app
        
      end
    end
  end
end



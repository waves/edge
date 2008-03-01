module Waves
  module Mapping
    
    # A set of pre-packed mapping rules for dealing with pretty URLs (that use names instead
    # of numbers to identify resources). There are two modules.
    # - GetRules, which defines all the GET methods for dealing with named resources
    # - RestRules, which defines add, update, and delete rules using a REST style interface
    #
    module PrettyUrls
      
      #
      # GetRules defines the following URL conventions:
      #
      #   /resources            # => get a list of all instances of resource
      #   /resource/name        # => get a specific instance of resource with the given name
      #   /resource/name/editor # => display an edit page for the given resource
      #
      module GetRules
          
        def self.included(target)
    
          target.module_eval do
      
            extend Waves::Mapping
      
      		  name = '([\w\-\_\.\+\@]+)'; model = '([\w\-]+)'
  
            # get all resources for the given model
            path %r{^/#{model}/?$} do | model |
              use( model.singular ) | controller { all } | view { |data| list( model => data ) }
            end

            # get the given resource for the given model
            path %r{^/#{model}/#{name}/?$} do | model, name |
              use(model) | controller { find( name ) } | 
                view { |data| show( model => data ) }
            end
  
            # display an editor for the given resource / model
            path %r{^/#{model}/#{name}/editor/?$} do | model, name |
              use(model) | controller { find( name ) } | 
                view { |data| editor( model => data ) }       
            end
      
          end
          
        end
    
      end
      
      #
      # RestRules defines the following URL conventions:
      #
      #   POST /resources            # => add a new resource using the POST variables
      #   POST /resource/name        # => update the given resource using the POST variables
      #   DELETE /resource/name      # => delete the given resource
      #
      module RestRules
          
        def self.included(target)
    
          target.module_eval do
      
            extend Waves::Mapping
      
      		  name = '([\w\-\_\.\+\@]+)'; model = '([\w\-]+)'
  
            # create a new resource for the given model
            path %r{^/#{model}/?$}, :method => :post do | model |
              use( model.singular )
              instance = controller { create }
              redirect( "/#{model.singular}/#{instance.name}/editor" )
            end

            # add / update the given resource for the given model
            path %r{^/#{model}/#{name}/?$}, :method => :post do | model, name |
              use(model) | controller { update( name ) }; redirect( url )
            end
  
            # delete the given resource for the given model
            path %r{^/#{model}/#{name}/?$}, :method => :delete do | model, name |
              use( model ) | controller { delete( name ) }
            end
      
          end
          
        end
        
      end
  
    end

  end

end
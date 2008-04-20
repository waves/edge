module Waves
  module Verify
    module Helpers
      module Mapping
      
        def mapping
          ::Waves::Application.instance.mapping
        end

        def path(*args,&block)
          mapping.path(*args,&block)
        end

        def url(*args,&block)
          mapping.url(*args,&block)
        end
      
      end
    end
  end
end
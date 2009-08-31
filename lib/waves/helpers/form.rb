module Waves

  module Helpers

    # Form helpers are used in generating forms. Since Hoshi already provides Ruby
    # methods for basic form generation, the focus of this helper is on providing methods
    # to handle things that go beyond the basics. 
    #
    # Example:
    #
    # editor( @blog.entry, :heading => 'Edit Blog Entry', :method => :put) {
    #   property @blog.entry, :name => :title, :type => :text
    #   property @blog.entry, :name => :content, :type => :text, :size => large
    #   property @blog.entry, :name => :published?, :type => :boolean
    # }
    #
    
    module Form

      def editor( instance, options = {}) 
        options = { :method => :put, :buttons => true, 
          :heading => instance.class.name.in_words.title_case }.merge( options )
        h1 options[:heading] if options[:heading]
        form( :method => :post, :action => paths.put( instance.key ) ) {
          input( :type => :hidden, :name => :_method, :value => :put ) if options[:method] == :put
          div.properties { yield }
          p( :class => 'button panel' ) { submit; cancel } if options[:buttons]
        }
      end

      def properties(&block)
        fieldset do
          yield
        end
      end

      def property( instance, options )
        div( :class => "property #{options[:type]} #{options[:size]}") {
          label options[:name].capitalize
          div( :class => 'control' ) { self.send( "#{options[:type]}_field", instance, options ) }
        }
      end

      def text_field( instance, options )
        if options[:size] == :large
          textarea( instance.send( options[:name] ), 
            :name => "#{instance.class.basename.snake_case}.#{options[:name]}" )
        else
          input( :name => "#{instance.class.basename.snake_case}.#{options[:name]}", 
            :type => :text, :value => instance.send( options[:name] ) )
        end
      end

      def integer_field( instance, options )
        input( :name => "#{instance.class.basename.snake_case}.#{options[:name]}", 
          :type => :text, :value => instance.send( options[:name] ) )
      end

      def float_field( instance, options )
        input( :name => "#{instance.class.basename.snake_case}.#{options[:name]}", 
          :type => :text, :value => instance.send( options[:name] ) )
      end

      def boolean_field( instance, options )
        on = instance.send( options[:name] )
        radio_button( 'Yes', "#{instance.class.basename.snake_case}.#{options[:name]}", 't', on )
        radio_button( 'No', "#{instance.class.basename.snake_case}.#{options[:name]}", 'f', !on )
      end

      def radio_button( label, name, value, on )
        # can't use hoshi input method here thx 2 checked 
        span label
        raw( "<input type='radio' name='#{name}' \
          value='#{value}' #{'checked' if on}/>" )
      end

      def file_field( instance, options )
        input( :type => :file, :name => "#{instance.class.basename.snake_case}.#{options[:name]}" )
      end

      def submit( label = "Save")
        input :type => :submit, :value => label
      end

      def cancel( label = "Cancel" )
        a label, :href => 'javascript:window.history.back()'
      end


    end

  end

end

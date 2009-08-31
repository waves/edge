require 'forwardable'

module Waves

  module Runtime

    class << self; attr_accessor :instance; end

    # Create a new Waves application instance.
    def load
      Dir.chdir( options[:directory] ) if options[:directory]
      Kernel.load( options[:startup] || 'startup.rb' )
      Runtime.instance = self
      options[:logger] ||= logger
    end

    # The 'mode' of the runtime determines which configuration it will run under.
    def mode ; options[:mode]||:development ; end

    # Returns true if debug was set to true in the current configuration.
    def debug? ; options[:debugger] or config.debug ; end

    # Returns the current configuration.
    def config ; Waves.main[:configurations][ mode ] ; end

    # Reload the modules specified in the current configuration.
    def reload ; config.reloadable.each { |mod| mod.reload } ; end

    # Start and / or access the Waves::Logger instance.
    def logger ; @log ||= Waves::Logger.start ; end

    # Provides access to the server mutex for thread-safe operation.
    def synchronize( &block ) ; ( @mutex ||= Mutex.new ).synchronize( &block ) ; end
    def synchronize? ; !options[ :turbo ] ; end

  end
  
  class << self 
    
    # Returns the most recently created instance of Waves::Runtime.
    def instance ; Waves::Runtime.instance ; end
  
    extend Forwardable
    def_delegators :instance, *%w( mode debug? config reload logger synchronize synchronize? )
    
  end

end

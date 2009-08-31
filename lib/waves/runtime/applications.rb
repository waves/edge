module Waves
  
  class Applications < Array
    def []( name ) ; self.find { |app| app.name.snake_case.to_sym == name } ; end
  end

  def self.config; instance.config ; end

  # The list of all loaded applications
  def self.applications ; @applications ||= Applications.new ; end

  # Access the principal Waves application.
  def self.main ; applications.first ; end

  # Register a module as a Waves application.
  def self.<< ( app ) ; applications << app ; end

end
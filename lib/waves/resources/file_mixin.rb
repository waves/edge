module Waves::Resources::FileMixin
  
  def load_from_file( path )
      http_cache( File.mtime( path ) ) { File.read( path ) } if File.exist?( path )
  end
  
end
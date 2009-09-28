module Waves::Resources::FileMixin
  
  def load_from_file( path )
    if File.exist?( path )
      http_cache( File.mtime( path ) ) {
        File.read( path )
      }
    end
  end
  
end
require "autocode"

module Blog

  module Resources
    include AutoCode
    auto_load true, :directories => "resources"

    class Map
      include Waves::Resources::Mixin

      on( true ) { to( :entry ) }

    end
  end
end

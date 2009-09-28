module Waves
  class Response
    module ClientError ; end
    module ClientErrors
      class NotFound < Packaged[404]
        include ClientError
      end
    end
  end
end
# paper_trail gem also provides a Railtie (Engine) in this require. It seems to
# work to just add initializers to that existing Railtie. If needed, though, we
# could define a different one, like "Railtie".
require 'rails'
require 'paper_trail/frameworks/rails/engine'

module PaperTrail
  module Rails
    class Engine
    end
  end
end

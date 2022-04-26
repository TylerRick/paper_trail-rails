require 'rails'
require 'paper_trail/frameworks/rails'

module PaperTrail
  module Rails
    # lib/paper_trail/rails/console.rb adds an initializer to this Railtie.
    #
    # paper_trail gem also provides a Railtie, PaperTrail::Railtie
    # (paper_trail/frameworks/rails/railtie.rb), but that is different from this one.
    #
    class Railtie < ::Rails::Railtie
    end
  end
end

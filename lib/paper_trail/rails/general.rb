# General helpers that aren't really specific to this project

module PaperTrail
  module Rails
    module General
      class << self
        def select_user(filter: :itself, other_allowed_values: [], prompt: 'Please enter a User id', required: true)
          User.logger.silence do
            puts 'id. user'
            filter.to_proc.(User.all).default_order.each do |user|
              puts "%4s. %s" % [user.id, user.inspect]
            end
          end

          user = nil
          until user.present? do
            print "#{prompt}: "
            input = gets.chomp
            case input
            when *other_allowed_values
              user = input
            else
              user = User.find(input) rescue nil
            end
            break unless required
          end
          user
        end
      end
    end
  end
end

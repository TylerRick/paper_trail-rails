# General helpers that aren't really specific to this project

module PaperTrail
  module Rails
    class << self
      def select_user(filter: :itself, other_allowed_values: [], other_values_prompt: '')
        User.logger.silence do
          puts 'id. user'
          filter.to_proc.(User.all).default_order.each do |user|
            puts "%4s. %s" % [user.id, user.inspect]
          end
        end
        other_values_prompt = " (#{other_values_prompt})" if other_values_prompt.present?

        user = nil
        until user.present? do
          print "Please enter the id of one of the users above (or any valid User id)#{other_values_prompt}: "
          input = gets.chomp
          case input
          when *other_allowed_values
            user = input
          else
            user = User.find(input) rescue nil
          end
        end
        user
      end
    end
  end
end

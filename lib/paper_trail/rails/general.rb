# General helpers that aren't really specific to this project

module PaperTrail
  module Rails
    module General
      class << self
        def select_user(filter: :itself, other_allowed_values: [], prompt: '"Please enter the index of one of the users above, or a valid User id', required: true)
          config = PaperTrail::Rails.config

          user_options = nil
          User.logger.silence do
            puts 'index. user'
            user_options = filter.to_proc.(User.all)
            user_options.each.with_index do |user, i|
              puts "%2s. %s" % [i + 1, user.inspect]
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
              if (i = Integer(input) rescue nil)
                user = user_options[i - 1] || (User.find(input) rescue nil)
              else  # allow for non-numeric ids like uuids
                user =                         User.find(input) rescue nil
              end
            end
            break unless required
          end
          user
        end
      end
    end
  end
end

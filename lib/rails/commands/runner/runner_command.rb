# This file must be at path lib/rails/commands/runner/runner_command.rb so it overrides the file
# with the same name in the railties gem. This is the only way to modify the class (prepend a
# module) before perform is called on it.

# pp $LOAD_PATH.index($LOAD_PATH.grep(/railties/).first)
# pp $LOAD_PATH.index($LOAD_PATH.grep(/paper_trail-rails/).first)

begin
  require 'paper_trail/rails'
rescue
  puts $!
  puts $!.backtrace
  raise
end

railties_lib = Gem.loaded_specs['railties'].full_require_paths[0]

require railties_lib + '/rails/commands/runner/runner_command'

require_relative '../../../paper_trail/rails/runner_command_extensions'

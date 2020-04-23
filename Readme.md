# PaperTrail::Rails

[![Gem Version][1]][2]
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](https://rdoc.info/github/TylerRick/paper_trail-rails/master)

An extension to [PaperTrail](https://github.com/paper-trail-gem/paper_trail)
that adds some useful automatic integrations with Rails:

- Automatically record which migration made the change in the version record (in
  the `command` attribute) when migrations make changes to data.
- Automatically record `rails console` as the command in the version record (in
  the `command` attribute).
- Automatically record the source location that initiated the change so you can
  figure out what caused caused the change later when inspecting a version
  record
- (Optional) Never forget to set the actor (whodunnit) when making changes in the `rails
  console`. It will prompt you to choose an actor user as soon as you try to
  make a change that would record a PaperTrail Version. (Enter `system` if you
  don't want any particular user recorded as the actor.)
- (Optional) Automatically ask for a reason whenever you make a change

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paper_trail-rails'
```

And then execute:

    $ bundle

Add and run this migration:
```
class VersionsAddSourceLocationCommandReason < ActiveRecord::Migration[5.2]
  def change
    change_table :versions do |t|
      t.text    :source_location
      t.text    :command
      t.text    :reason
    end
    change_table :versions do |t|
      t.index   :command
      t.index   :reason
    end
  end
end
```

## Configuration

Add to `config/initializers/paper_trail.rb` and change as needed:

```ruby
PaperTrail::Rails.configure do |config|
  config.console.ask_for_user      = true
  config.console.require_user      = false
  config.console.auto_reset_user   = false

  config.console.ask_for_reason    = true
  config.console.require_reason    = false
  config.console.auto_reset_reason = true

  config.user_filter = ->(users) { users.admins }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/paper_trail-rails.

[1]: https://badge.fury.io/rb/paper_trail-rails.svg
[2]: https://rubygems.org/gems/paper_trail-rails

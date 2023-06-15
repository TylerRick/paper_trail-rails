## 0.6.1 (2023-06-15)
- Add `PaperTrail.metadata`, `PaperTrail.reverse_update_metadata`
- Change `set_default_metadata` to only set `command` to `default_command` if it hasn't been set yet. This
  fixes bug where the command set by `RunnerCommandExtensions` got overwritten when the `whodunnit`
  callback called `set_default_metadata` again.

## 0.6.0 (2023-06-14)
- Include the rails subcommand (`'rails console'`, etc.) in the `command` metadata, not just `'rails'`
- When using `rails runner`, include the full Ruby code/file that was run in the `command` metadata.

## 0.5.2 (2022-04-26)
- Fix: Don't update `PaperTrail.request.controller_info[:reason]` if reason is already present and we didn't even ask for a new reason

## 0.5.1 (2022-04-26)
- Update due to upstream paper_trail defining `PaperTrail::Railtie` instead of `PaperTrail::Rails::Engine`

## 0.5.0 (2022-04-26)
- Don't ask for reason if `PaperTrail.request.controller_info[:reason]` is already present.

  For example, if you call a method that programatically sets the reason, then it shouldn't ask you to
  manually type in a reason.

## 0.4.0 (2020-04-23)
- Allow user to be selected by index in addition to id
- Add `config.select_user_inspect`
- Fix: Remove `.default_order` which may not be defined. Included as config example instead.
- Fix: Replace `respond.id` with `respond_to?(:id)`
- Fix: Should use `require_user` rather than `require_reason`

## 0.3.0 (2019-09-16)
- Fix: When running `db:migrate:redo`, command got recorded as `"rails db:migrate:redo VERSION=2019…"`
  instead of as `"rails db:migrate: MigrationName (up)"` as intended.
- Add `config.source_location_filter`

## 0.2.2 (2019-07-18)
- Fix: undefined method `user_for_test' when running `rails console -e test`

## 0.2.0 (2019-05-23)

### Breaking changes
- Moved config specific to rails console under `config.console`
- Rename `PaperTrail::Rails.set_default_paper_trail_metadata` to `PaperTrail::Rails.set_default_metadata`
- Rename `PaperTrail::Rails.select_paper_trail_user_or_system` to `PaperTrail::Rails.select_user`
- and others

### Added
- Automatically reset reason so it doesn't keep assuming and using the same reason for all changes you make in this console session.(Can be disabled with `config.console.auto_reset_reason = false`)
- Add `config.console.ask_for_user`, `config.console.require_user`, and `config.console.auto_reset_user`

## 0.1.0 (2019-05-22)

Initial release

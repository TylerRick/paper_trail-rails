## 0.4.0 (2020-04-23)
- Allow user to be selected by index in addition to id
- Add config.select_user_inspect
- Fix: Remove .default_order which may not be defined. Included as config example instead.
- Fix: Replace respond.id with respond_to?(:id)
- Fix: Should use require_user rather than require_reason

## 0.3.0 (2019-09-16)
- Fix: When running db:migrate:redo, command got recorded as "rails db:migrate:redo VERSION=2019…"
  instead of as "rails db:migrate: MigrationName (up)" as intended.
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

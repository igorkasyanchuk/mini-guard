# mini-guard (run appropriate specs while you are codding)

Not a new idea of executing appropriate specs when source code is changed. But in this implementation it's at least can run not only 1 to 1 related spec but also few additional.

For example, you have an average Rails app (with factories, and Rspec). It contains 20 controllers, few namespaces, 15 models, helpers, SLIM views, and 100 specs. 

Imagine that one of the models is "User" model. Also you have a public users_controller, and in admin namespace one more users_controller, plus 2 users_helper.

So, with this gem when you are editing:

| You editing the File | Specs automatically executed |
|-----|-----------------|
| models/user_spec.rb | spec/models/user_spec.rb, specs/controllers/users_controller_spec.rb, specs/controllers/admin/users_controller_spec.rb, spec/helpers/users_helper_spec.rb, spec/helpers/admin/users_helper_spec.rb |
| controllers/users_controller.rb | specs/controllers/users_controller_spec.rb |
| controllers/admin/users_controller.rb | specs/controllers/admin/users_controller_spec.rb |
| helpers/admin/users_controller.rb | specs/helpers/users_helper_spec.rb |
| specs/helpers/users_helper_spec.rb | specs/helpers/users_helper_spec.rb |
| specs/models/user_spec.rb | specs/models/user_spec.rb |
| views/users/index.html.slim | specs/controllers/users_controller_spec.rb |


**Main difference with other gems that when you are making a change to Model it will execute also matched controllers/helpers/workers/etc specs**

## Installation

    $ gem install mini-guard

## Usage

In your Rails app execute `mg` or `mini-guard` command.

## TODO

- show in real time process of specs execution
- support mini_tests and other frameworks
- add support of Ctrl+C to interrapt specs execution and double Ctrl+C to exit mini-guard
- specs for gems
- support non-Rails apps
- ability to define Rules on what and how execute

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/igorkasyanchuk/mini-guard.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


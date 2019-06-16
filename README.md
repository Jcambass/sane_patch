<img src="https://raw.githubusercontent.com/Jcambass/sane_patch/master/logo.png" width="100" height="100">

SanePatch is a simple and non intrusive helper that aims to make monkey patching a little bit safer.

It achieves this by only applying your patches to a specific version of a gem and raising a exception if the gem version changed. This means that you will always double check that your patches still work after upgrading gems. No surprises anymore!

## But wait.. Isn't monkey patching bad?

As with many things in life there is no pure good or bad. Monkey patching can be dangerous in certain situations and should be avoided sometimes but there are reasons to use it.

Good reasons to monkey patch a gem could be:
- Fixing a small bug in a broken gem until a new version of it is released.
- Performance optimizing a specific method of a gem that is used in a hot code path.
- Probably many more...

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sane_patch'
```

And then execute:

    $ bundle

## Usage

The usage of SanePatch is straight forward:


```ruby
SanePatch.patch('<gem name>', '<current gem version>') do
  # Apply your patches here the same way as usual.
end
```

A more specific example:

```ruby
Greeter.greet # => 'Hello'

# Let's patch the `Greeter.greet` method to output 'Hello Folks'
module GreeterPatch
  def greet
    "#{super} Folks"
  end
end

# We currently have version 1.1.0 of the greeter gem
SanePatch.patch('greeter', '1.1.0') do
  Greeter.prepend(GreeterPatch)
end

Greeter.greet # => 'Hello Folk'
```

If somebody updates the gem version the patch will raise as soon as its code path is executed:
```
It looks like the greeter gem was upgraded. (RuntimeError)
There are patches in place that need to be verified.
Make sure that the patch at initializers/greeter_patch.rb:8 is still needed and working.
```

### Providing additional information

If you patch a known bug in a gem it might be useful to provide additional information why the patch is needed and when it can be removed.

```ruby
Greeter.silence # => nil

module GreeterPatch
  def silence
    ''
  end
end

details = <<-MSG
  The `silence` method should output an empty string rather than nil.
  This is a known issue and will be fixed in the next release.
  See: https://github.com/Jcambass/greeter/issues/45
MSG

SanePatch.patch('greeter', '1.1.0', details: details) do
  Greeter.prepend(GreeterPatch)
end

Greeter.silence # => ''
```

The additionally provided details will also show up in the exception message.

```
It looks like the greeter gem was upgraded. (RuntimeError)
There are patches in place that need to be verified.
Make sure that the patch at initializers/greeter_patch.rb:8 is still needed and working.
Details:
The `silence` method should output an empty string rather than nil.
This is a known issue and will be fixed in the next release.
See: https://github.com/Jcambass/greeter/issues/45
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jcambass/sane_patch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SanePatch project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Jcambass/sane_patch/blob/master/CODE_OF_CONDUCT.md).

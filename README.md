# Captchah

A Rails captcha gem that attempts to determine whether or not a user is human.

## Installation

Add this line to your application's Gemfile:

```
gem 'captchah', '~> 1.1'
```

And execute:

```
$ bundle
```

## Requirements

ImageMagick or GraphicsMagick command-line tool has to be installed. You can check if you have it installed by running:

```
$ convert -version
```

## Dependencies

```
gem 'rails', '~> 5'
```

```
gem 'mini_magick', '~> 4.0'
```

## Usage

Include the Captchah module into your controller. Example:

```
class YourController < ApplicationController
  include Captchah
```

Add the captchah_tag form helper to your form. Note, only 1 captchah_tag per form is allowed. Example:

```
<%= form_tag('/your-path') do %>
  <%= captchah_tag %>
```

Note, the gem uses the 'Verdana' font to create the puzzle image. If the font is missing from your system, please install it, or specify a different one as the 'puzzle_font' argument shown below. To see what fonts are available to ImageMagick, you can run:

```
$ convert -list font
```

Once a user submits your form, you can verify if they have typed in the correct characters by calling the verify_captchah method inside your controller. Example:

```
class YourController < ApplicationController
  include Captchah

  def create
    redirect_to('/your-path') unless verify_captchah == :valid
  end
```

## Details

The captchah_tag form helper accepts the following arguments:
```
captchah_tag(
  id: 'unique-id',           # String value                     Default: (automatically generated)
  difficulty: 3,             # Integer value between 1 and 5    Default: 3
  expiry: 10.minutes,        # ActiveSupport::Duration object   Default: 10.minutes
  width: 140,                # Integer value                    Default: 140(pixels)
  action_label: 'Type...',   # String value                     Default: 'Type the letters you see:'
  reload_label: 'Reload',    # String value                     Default: 'Reload'
  reload_max: 5,             # Integer value                    Default: 5
  reload: true,              # Boolean value                    Default: true
  css: true,                 # Boolean value                    Default: true
  puzzle_font: 'Verdana'     # String value                     Default: 'Verdana'
)
```

The verify_captchah method returns the following statuses:
```
:valid                          # The user has typed in the correct characters.
:invalid                        # The user has not typed in the correct characters.
:expired                        # The captcha has expired.
:no_params                      # params[:captchah] is empty.
```

## Running the tests

```
$ bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/evgeniradev/captchah](https://github.com/evgeniradev/captchah).

## License

Captchah is released under the MIT License. See LICENSE for details.

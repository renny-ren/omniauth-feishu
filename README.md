# OmniAuth Feishu

Strategy to authenticate with Feishu via OAuth2 in OmniAuth.

[![Gem Version](https://badge.fury.io/rb/omniauth-feishu.svg)](http://badge.fury.io/rb/omniauth-feishu)
[![Build Status](https://travis-ci.org/renny-ren/omniauth-feishu.svg?branch=master)](https://travis-ci.org/renny-ren/omniauth-feishu)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-feishu'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install omniauth-feishu

## Before You Begin

You should have already created your app in feishu platform, if not, go to https://open.feishu.cn/app/ to create one.

Take note of your App Id and App Secret because that is what your web application will use to authenticate against the Feishu API.
Make sure to set a redirect URL or else you may get authentication error.

## Usage

Here's an example for adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :feishu, 'App ID', 'App Secret'
end
```

## Devise Usage
Adapted from [Devise OmniAuth Instructions](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)

```ruby
# app/models/user.rb
class User < ApplicationRecord
  #...
  devise :omniauthable, omniauth_providers: %i[feishu]
  #...
end

# config/initializers/devise.rb
config.omniauth :feishu, 'App ID', 'App Secret'

# Below controller assumes callback route configuration following 
# in config/routes.rb
Devise.setup do |config|
  # ...
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end

# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def feishu
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.feishu"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:alert] = request.env["omniauth.error"]
    redirect_to root_path
  end
end
```

Devise will create the following url methods:
- user_feishu_omniauth_authorize_path
- user_feishu_omniauth_callback_path

So you may add a button like this:
```
<%= link_to "Sign in with feishu", user_feishu_omniauth_authorize_path, class: "btn" %>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renny-ren/omniauth-feishu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

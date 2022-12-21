# frozen_string_literal: true

require 'rails'
require 'mini_magick'
require 'active_support/time'
require 'active_support/core_ext/string/output_safety'
require 'action_controller'
require 'captchah'
require 'support/all_args'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    secret_key_base = 'a' * 32

    allow(Rails).to(
      receive_message_chain(:application, :secrets, :secret_key_base)
        .and_return(secret_key_base)
    )
  end

  config.include(AllArgs)
end

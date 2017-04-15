require "bundler/setup"
require "rails/all"
require 'rspec/rails'
require "letter_opener_web_s3"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
end

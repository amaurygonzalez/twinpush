require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'

require 'twinpush'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
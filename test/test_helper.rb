ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/test_unit'
Mocha::Configuration.prevent(:stubbing_non_existent_method)

require 'webmock/minitest'

class ActiveSupport::TestCase
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  Capybara.app = Rails.application
end

# Include path
$: << File.dirname(__FILE__)+'/../lib'

# Requires
require 'rspec'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'pages'
require 'selenium-webdriver'
require 'gmail'
require 'chronic'
require 'securerandom'
require 'api_client'
require 'rest_client'
require 'show_me_the_cookies'
require 'json'
require 'capybara/poltergeist'
require 'rbconfig'
require 'capybara-screenshot/cucumber'

World(ShowMeTheCookies)

# Configuration - TODO load from a file
$config = {
    :global => {
        :reuse_browser_for_outline => true,
    }
}

Capybara.ignore_hidden_elements = false




# Capybara/browser setup (needs to be here rather than hooks.rb as
# "dry-run" mode doesn't use Capybara)
Before do |scenario|
    if Capybara.current_driver == :selenium_chrome
        page.driver.browser.manage.window.maximize
    end

    # Try to prevent onunload popups from breaking subsequent tests by killing them
    page.driver.execute_script("window.onbeforeunload = undefined;")
    page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertPresentError
end

Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.native_events = true
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

Capybara.register_driver :debug do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.add_extension "features/support/firebug_1.12.8.xpi"
  profile.add_extension "features/support/firepath.xpi"
  Capybara::Selenium::Driver.new app, :profile => profile
end

Capybara.register_driver :ie11 do |app|
  Capybara::Selenium::Driver.new(app, :browser => :internet_explorer, :desired_capabilities => {:ignoreZoomSetting => true, :IntroduceInstabilityByIgnoringProtectedModeSettings => true, :EnsureCleanSession => true })
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, :js_errors => false)
end

Capybara.default_max_wait_time=30

case ENV['BROWSER']
    when 'poltergeist'
        Capybara.javascript_driver = Capybara.default_driver = :poltergeist
    else
        Capybara.default_driver = :poltergeist
end

# TODO this is a bit messy
case ENV['ENV']
    when 'live'
        ENV['BASE_URL'] = 'https://www.redbridge.gov.uk/'
    when 'dev'
        ENV['BASE_URL'] = 'https://v3dev.redbridge.gov.uk/'
    else
        ENV['BASE_URL'] = 'https://v3test.redbridge.gov.uk/'
end


Capybara.app_host = ENV['BASE_URL']
#Capybara.save_and_open_page_path = "screenshots"


# Monkey patch the Capybara class to prevent it destroying the session
# if we want to reuse it.
module Capybara
    class << self
        alias_method :old_reset_sessions!, :reset_sessions!
        def reset_sessions!
            # Destroy the browser unless we want to reuse it and have already
            # created one for this scenario
            if !($reuse_browser && $reused_browser_name == $scenario_name)
                self.old_reset_sessions!
                $reusing_browser = false
            else
                $reusing_browser = true
            end

            # Store the reuse browser scenario to ensure we only reuse it
            # within this scenario outline
            if $reuse_browser
                $reused_browser_name = $scenario_name
            end
        end
    end
end

# TODO investigate ways of making the api client into a singleton
$api_client = ApiClient::SitesApiClient.new

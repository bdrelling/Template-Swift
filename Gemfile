source 'https://rubygems.org'

gem 'dotenv', '~> 2.7.6'
gem 'fastlane', '~> 2.199.0'
gem 'xcode-install', '~> 2.8.0'

# gems not needed by Fastlane
gem 'rubocop', '~> 1.22.1', require: false

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

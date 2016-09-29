require 'cucumber/rake/task'
require 'rubygems/package_task'

require 'yaml'
sys_config = YAML.load_file('features/support/config.yml')
environment_key = 'dev'


def exclude_inactive_tags
  '--tags ~@not_ready --tags ~@manual'
end

def call_bundler_and_execute_rake_task(name)
  run_bundler
  $stdout.puts name
  Rake.application[name].execute
end

puts "Running on ruby #{RUBY_VERSION}"

sys_config.each_key do |environment|
  puts "Running on ruby #{RUBY_VERSION}"
  desc "All features on #{environment}"
  task "#{environment}".to_sym do
    ENV[environment_key] = environment
    call_bundler_and_execute_rake_task("default")
  end

  desc "Run a specific feature  on #{environment}"
  task :"#{environment}-feature".to_sym, :feature_name do |t, args|
    ENV[environment_key] = environment
    feature_file = args[:feature_name]
    puts "Run feature: #{feature_file}"
    ENV['FEATURE']=feature_file
    call_bundler_and_execute_rake_task("default")
  end

  desc "Run all scenarios with a specified tag on #{environment}"
  task :"#{environment}-tag".to_sym, [:tag_name] do |t, args|
    ENV[environment_key] = environment
    tag_name = args[:tag_name]
    puts "Run all scenarios that are tagged with: #{tag_name}"
    run_bundler
    Cucumber::Rake::Task.new("dynamic") do |t|
      t.cucumber_opts = "--tags @#{tag_name} #{exclude_inactive_tags}"
    end
    Rake.application[:dynamic].execute
  end

  desc "Run all scenarios without a specified tag on #{environment}"
  task :"#{environment}-not-tag".to_sym, [:tag_name] do |t, args|
    ENV[environment_key] = environment
    tag_name = args[:tag_name]
    puts "Run all active scenarios that are not tagged with: #{tag_name}"
    run_bundler
    Cucumber::Rake::Task.new("dynamic") do |t|
      t.cucumber_opts = "--tags ~@#{tag_name} #{exclude_inactive_tags}"
    end
    Rake.application[:dynamic].execute
  end

end

Cucumber::Rake::Task.new(:default, 'All completed features') do |t|
  t.cucumber_opts = "#{exclude_inactive_tags}"
end

Cucumber::Rake::Task.new("default-teamcity", "All completed features in teamcity") do |t|
  t.cucumber_opts = "--format junit --out=TestResults #{exclude_inactive_tags}"
end

Cucumber::Rake::Task.new("smoketest-teamcity", "Smoke tests in teamcity") do |t|
  t.cucumber_opts = "--format junit --out=TestResults --tags @smoke"
end


def run_bundler
  puts 'Starting bundler ....'
  system 'bundle install'
end


desc 'Run all tests against testing environment'
  task :test do
    run_profile('test')
  end

require 'rspec/core/rake_task'
require 'pact_broker/client/tasks'

$: << './lib'

RSpec::Core::RakeTask.new(:spec)

PactBroker::Client::PublicationTask.new do | task |
  task.consumer_version = ENV['GIT_COMMIT'] || `git rev-parse --short --verify HEAD`.strip
  task.pact_broker_base_url = 'http://pact-broker:9292'
  task.branch = ENV['GIT_BRANCH'] || `git name-rev --name-only HEAD`.strip
  # task.tag_with_git_branch = true|false # Superseeded by first class `branch` support
  # task.tags = ["dev"] # optional
  # task.build_url = ENV["CI_BUILD_URL"] # Supported from v1.59.0
  # task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} # optional
  # task.pact_broker_token = "1234abcd" # Bearer token
end

task :default => :spec
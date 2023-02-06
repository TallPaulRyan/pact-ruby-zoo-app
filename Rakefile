require 'rspec/core/rake_task'
require 'pact_broker/client/tasks'

$: << './lib'

RSpec::Core::RakeTask.new(:spec)

PactBroker::Client::PublicationTask.new do | task |
  task.consumer_version = ENV['GIT_COMMIT'] || `git rev-parse --short --verify HEAD`.strip
  task.pact_broker_base_url = 'http://pact-broker:9292'

  # This can give unintended results when merging feature branches into main.
  # A single commit can have multiple branch names. 'show-current' might be
  # a bitter instruction, at least for local dev.
  # task.branch = ENV['GIT_BRANCH'] || `git name-rev --name-only HEAD`.strip
  task.branch = `git branch --show-current`


  # task.tag_with_git_branch = true|false # Superseeded by first class `branch` support
  # task.tags = ["dev"] # optional
  # task.build_url = ENV["CI_BUILD_URL"] # Supported from v1.59.0
  # task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} # optional
  # task.pact_broker_token = "1234abcd" # Bearer token
end

task :default => :spec

namespace :env do

  desc 'list existing envs.'
  task :list do
    p "Listing exsiting environments via pact-broker list-environments."
    result = `pact-broker list-environments`
    puts result.strip
  end

  desc 'Create environment - rake env:create[<env>].'
  task :create, [:env] do |t, args|
    p "Creating #{args[:env]} env via pact-broker create-environment..."
    result = `pact-broker create-environment --name=#{args[:env]}`
    puts result.strip
  end

  desc 'Deploy to environment.'
  task :deploy, [:env] do |t, args|
    p "Executing pact-broker record-deployment..."
    participant = 'Animal Service'
    provider_version = ENV['GIT_COMMIT'] || `git rev-parse --short --verify HEAD`.strip
    result = `pact-broker record-deployment --environment=#{args[:env]} --pacticipant='#{participant}' --version=#{provider_version}`
    puts result.strip
  end
end
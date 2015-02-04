require 'rspec/core/rake_task'

namespace :spec do
  desc "Run all but the acceptance specs"
  RSpec::Core::RakeTask.new(:no_acceptance) do |t|
    t.exclude_pattern = "spec/acceptance/**/*_spec.rb"
  end
end


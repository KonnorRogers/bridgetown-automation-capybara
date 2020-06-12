# frozen_string_literal: true

require 'test_helper'
require 'shell'

GITHUB_REPO_NAME = 'bridgetown-automation-capybara'
BRANCH = `git branch --show-current`.chomp.freeze || 'master'

module CapybaraAutomation
  class IntegrationTest < Minitest::Test
    def setup
      Rake.rm_rf(TEST_APP)
      Rake.mkdir_p(TEST_APP)
    end

    def read_test_file(filename)
      File.read(File.join(TEST_APP, filename))
    end

    def read_template_file(filename)
      File.read(File.join(TEMPLATES_DIR, filename))
    end

    def test_it_works_with_local_automation
      Rake.cd TEST_APP

      Rake.sh('bundle exec bridgetown new . --force ')
      Rake.sh('bundle config --local build.nokogiri --use-system-libraries')
      Rake.sh('bundle install')

      rspec = '1'
      spec_convention = '2'
      exe = "bridgetown apply '../bridgetown.automation.rb'"

      simulate_stdin(exe, rspec, spec_convention)

      capybara_helper_file = read_test_file('capybara_helper.rb')
      rspec_helper_file = read_template_file('rspec_helper.rb.tt')

      assert_match(/#{rspec_helper_file}/, capybara_helper_file)
    end

    # Have to push to github first, and wait for github to update
    # def test_it_works_with_remote_automation
    #   Rake.cd TEST_APP

    #   github_url = 'https://github.com'
    #   user_and_reponame = "ParamagicDev/#{GITHUB_REPO_NAME}/tree/#{BRANCH}"

    #   file = 'bridgetown.automation.rb'

    #   url = "#{github_url}/#{user_and_reponame}/#{file}"

    #   Rake.sh("bridgetown new . --force --apply='#{url}'")

    #   run_assertions
    # end
  end
end

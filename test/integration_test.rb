# frozen_string_literal: true

require 'test_helper'
require 'bundler'

GITHUB_REPO_NAME = 'bridgetown-automation-capybara'
BRANCH = `git branch --show-current`.chomp.freeze || 'master'

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

  def run_assertions; end

  def test_it_works_with_local_automation
    Dir.chdir(TEST_APP)

    system("bridgetown new . --force --apply='../bridgetown.automation.rb'")
  end

  # Have to push to github first, and wait for github to update
  # def test_it_works_with_remote_automation
  #   Rake.cd TEST_APP
  #   Rake.sh('bridgetown new . --force')

  #   github_url = 'https://github.com'
  #   user_and_reponame = "ParamagicDev/#{GITHUB_REPO_NAME}/tree/#{BRANCH}"

  #   file = 'bridgetown.automation.rb'

  #   url = "#{github_url}/#{user_and_reponame}/#{file}"

  #   Rake.sh("bridgetown apply #{url}")

  #   run_assertions
  # end
end

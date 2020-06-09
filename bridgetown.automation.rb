# frozen_string_literal: true

require 'fileutils'
require 'shellwords'

# Dynamically determined due to having to load from the tempdir
@current_dir = File.expand_path(__dir__)

# If its a remote file, the branch is appended to the end, so go up a level
# IE: https://blah-blah-blah/bridgetown-plugin-tailwindcss/master
ROOT_PATH = if __FILE__ =~ %r{\Ahttps?://}
              File.expand_path('../', __dir__)
            else
              File.expand_path(__dir__)
            end

puts ROOT_PATH

DIR_NAME = File.basename(ROOT_PATH)

GITHUB_PATH = "https://github.com/ParamagicDev/#{DIR_NAME}.git"

def determine_template_dir(current_dir = @current_dir)
  File.join(current_dir, 'templates')
end

def require_libs
  source_paths.each do |path|
    Dir["#{path}/lib/*.rb"].sort.each { |file| require file }
  end
end

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'

    source_paths.unshift(tempdir = Dir.mktmpdir(DIR_NAME + '-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    run("git clone --quiet #{GITHUB_PATH.shellescape} #{tempdir.shellescape}")

    if (branch = __FILE__[%r{#{DIR_NAME}/(.+)/bridgetown.automation.rb}, 1])
      Dir.chdir(tempdir) { system("git checkout #{branch}") }
      @current_dir = File.expand_path(tempdir)
    end
  else
    source_paths.unshift(ROOT_PATH)
  end
end

def read_template_file(filename)
  File.read(File.join(determine_template_dir, filename))
end

def add_capybara_to_bundle
  gems = %w[capybara apparition]
  run 'bundle config --local build.nokogiri --use-system-libraries'

  gems.each do |new_gem|
    # Redirect to /dev/null so we dont clutter stdout
    if system(`bundle info #{new_gem} 1> /dev/null`)
      say "You already have #{new_gem} installed.", :red
      say 'Skipping...\n', :red
      next
    end

    run "bundle add #{new_gem} -g 'testing'"
  end
end

def do_bundle
  Bundler.with_unbundled_env { run 'bundle install' }
end

def ask_questions(config)
  ask_for_testing_framework(config)
  ask_for_naming_convention(config)
end

def ask_for_input(question, answers)
  answer = nil

  provide_input = "Please provide a number (1-#{answers.length})"

  allowable_answers = answers.keys
  loop do
    say "\n#{question}"
    answers.each { |num, string| say "#{num}.) #{string}", :cyan }
    answer = ask("\n#{provide_input}:\n ", :magenta).strip.to_i

    return answer if allowable_answers.include?(answer)

    say "\nInvalid input given", :red
  end
end

def ask_for_testing_framework(config)
  question = 'What testing framework would you like to use?'

  answers = config.frameworks

  input = ask_for_input(question, answers)

  config.framework = answers[input]
end

def ask_for_naming_convention(config)
  question = 'What naming convention would you like use?'

  answers = config.naming_conventions

  input = ask_for_input(question, answers)

  config.naming_convention = answers[input]
end

add_template_repository_to_source_path
require_libs

config = CapybaraAutomation::Configuration.new

add_capybara_to_bundle
# run "bundle add capybara -g 'testing'"
# do_bundle
ask_questions(config)

p config

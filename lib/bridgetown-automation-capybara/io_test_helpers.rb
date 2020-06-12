# frozen_string_literal: true

require 'pty'

module CapybaraAutomation
  module IoTestHelpers
    # def simulate_stdin(exe, *inputs)
    #   PTY.spawn(exe) do |_stdout, stdin, _pid|
    #     inputs.flatten.each { |str| stdin.puts(str) }
    #   end
    # end
    # def simulate_stdin(*inputs)
    #   io = StringIO.new
    #   inputs.flatten.each { |str| io.puts(str) }
    #   io.rewind

    #   actual_stdin = $stdin
    #   $stdin = io
    #   yield
    # ensure
    #   $stdin = actual_stdin
    # end
  end
end

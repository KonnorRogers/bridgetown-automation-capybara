# frozen_string_literal: true

module CapybaraAutomation
  class Configuration
    # Invert so we can call TEST_FRAMEWORK_OPTIONS[1] #=> :rspec
    FRAMEWORKS = {
      rspec: 1,
      minitest: 2,
      test_unit: 3
    }.invert

    NAMING_CONVENTION = {
      test: 1,
      spec: 2
    }.invert

    attr_accessor :framework, :naming_convention

    def initialize
      @framework = nil
      @naming_convention = nil
    end

    def frameworks
      FRAMEWORKS
    end

    def naming_conventions
      NAMING_CONVENTION
    end
  end
end

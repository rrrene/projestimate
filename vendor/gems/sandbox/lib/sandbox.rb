require "sandbox/version"

module Sandbox
  class Sandbox
    attr_accessor :description_sandbox,
                  :list_sandbox,
                  :integer_sandbox,
                  :float_sandbox,
                  :date_sandbox

    def initialize(input)
      @description_sandbox = input[:description_sandbox]
      @list_sandbox = input[:list_sandbox]
      @integer_sandbox = input[:integer_sandbox].to_i
      @float_sandbox = input[:float_sandbox].to_f
      @date_sandbox = input[:date_sandbox]
    end

    def get_description_sandbox
      @description_sandbox
    end

    def get_list_sandbox
      @list_sandbox
    end

    def get_integer_sandbox
      @integer_sandbox
    end

    def get_float_sandbox
      @float_sandbox
    end

    def get_date_sandbox
      @date_sandbox
    end

  end
end

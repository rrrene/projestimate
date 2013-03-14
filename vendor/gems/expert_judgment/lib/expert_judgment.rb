require "expert_judgment/version"

module ExpertJudgment

  # Expert Judgment gem definition
  class ExpertJudgment
    attr_accessor :effort_per_hour, :minimum, :most_likely, :maximum, :probable

    def initialize(elem)
      @effort_per_hour = elem[:effort_per_hour]
    end

    def set_minimum(elem)
      @minimum = elem[:minimum].to_f
    end

    def set_maximum(elem)
      @maximum = elem[:maximum].to_f
    end

    def set_most_likely(elem)
      @most_likely = elem[:most_likely].to_f
    end

    #GETTERS
    def get_probable
      ( (@minimum + (4*@most_likely) + @maximum) / 6 ).to_f
    end

    def get_effort_per_hour
      @effort_per_hour
    end

  end

end

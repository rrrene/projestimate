require "hamon_model/version"

module HamonModel
  class HamonModel
    attr_accessor :k, :r, :p, :m, :e, :s, :d

    def initialize(input)
      @k = input[:ksloc].to_f
      @r = input[:real_time_constraint].to_f
      @p = input[:platform_maturity].to_f
      @m = input[:methodology].to_f
    end

    def get_effort_man_week
      (450/(@p+@m))*(1 - Math.exp(((-1)*@k*@k*0.01)/32))
    end

    def get_schedule
      (@k/2.5)*(1+(@r/10))
    end

    def get_defects
      (Math.sqrt(@k))*@k*(1/@m)
    end
  end
end

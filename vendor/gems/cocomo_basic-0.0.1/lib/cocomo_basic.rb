module CocomoBasic

  #Definition of CocomoBasic
  class CocomoBasic

    attr_accessor :coef_a, :coef_b, :coef_c, :coef_kls, :complexity

    #Constructor
    def initialize(elem)
      case elem[:complexity]
        when 'organic'
          set_cocomo_organic(elem)
        when 'semidetached'
          set_cocomo_semidetached(elem)
        when 'semidetached'
          set_cocomo_embedded(elem)
        else
          set_cocomo_organic(elem)
      end
    end

    #Setters
    def set_cocomo_organic(elem)
      @coef_a = 2.4
      @coef_b = 1.05
      @coef_c = 0.38
      @coef_kls = elem[:ksloc].to_f
      @complexity = 'organic'
    end

    def set_cocomo_semidetached(elem)
      @coef_a = 3
      @coef_b = 1.12
      @coef_c = 0.35
      @coef_kls = elem[:ksloc].to_f
      @complexity = 'semidetached'
    end

    def set_cocomo_embedded(elem)
      @coef_a = 3.6
      @coef_b = 1.2
      @coef_c = 0.32
      @coef_kls = elem[:ksloc].to_f
      @complexity = 'embedded'
    end

    #Getters
    #Return effort
    def get_effort_per_hour
      res =  @coef_a*(coef_kls**@coef_b) * 152
      return res.to_f
    end

    #Return delay
    def get_delay
      return 2.5*(get_effort_per_hour**@coef_c).to_f
    end

    #Return end date
    def get_end_date
      return Time.now + get_delay.to_i.months
    end

    #Return staffing
    def get_staffing
      return get_effort_per_hour / get_delay
    end

    def get_complexity
      @complexity
    end
  end

end

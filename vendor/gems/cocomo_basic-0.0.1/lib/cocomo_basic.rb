module CocomoBasic

  #Definition of CocomoBasic
  class CocomoBasic

    attr_accessor :coef_a, :coef_b, :coef_c, :coef_kls, :complexity

    #Constructor
    def initialize(elem)
      case elem[:complexity].underscore
        when 'organic'
          set_cocomo_organic(elem)
        when 'semi-detached'
          set_cocomo_semidetached(elem)
        when 'embedded'
        when 'embedded'
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
      @complexity = 'semi-detached'
    end

    def set_cocomo_embedded(elem)
      @coef_a = 3.6
      @coef_b = 1.2
      @coef_c = 0.32
      @coef_kls = elem[:ksloc].to_f
      @complexity = 'embedded'
    end

    #Getters
    #Return effort (in man-hour)
    def get_effort_man_hour
      return (152 * @coef_a*(coef_kls**@coef_b)).to_f
    end

    #Return delay (in hour)
    def get_delay
      return (152 * 2.5*((get_effort_man_hour/152)**@coef_c)).to_f
    end

    #Return end date
    def get_end_date
      return Time.now + (get_delay/152).to_i.months
    end

    #Return staffing
    def get_staffing
      return get_effort_man_hour / get_delay
    end

   def get_complexity
     @complexity
   end
  end

end

require "rubystats"

module Doughnut

  class PredictedReturn

    def initialize(avg_return = 0, standard_deviation = 0)
      @avg_return = avg_return
      @standard_deviation = standard_deviation
    end

    def return(num_data_points = 1)
      return @avg_return if @standard_deviation == 0
      Rubystats::NormalDistribution.new(@avg_return, @standard_deviation).rng
    end

  end

end

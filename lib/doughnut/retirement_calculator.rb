module Doughnut

  class RetirementCalculator

    attr_accessor :death_date, :portfolio_return

    def initialize
      @death_date = Date.new(2067,7,19)
      @portfolio_return = 0.1
    end

    def retirement_date(total_expenses, monthly_incomes)
      return Date.today if total_expenses == 0
      return @death_date if monthly_incomes.length == 0
      running_income = 0
      monthly_incomes.each do |h|
        running_income += h[:income]
        return h[:date] if running_income >= total_expenses
      end
    end

  end

end
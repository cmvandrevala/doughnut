module Doughnut

  class RetirementCalculator

    attr_accessor :death_date, :inflation_rate, :monthly_expense
    attr_accessor :income_growth_rate, :portfolio_return
    attr_accessor :monthly_income

    def initialize
      @death_date = Date.new(2067,7,19)
      @inflation_rate = 0.0322
      @income_growth_rate = 0.01
      @portfolio_return = 0.1
      @monthly_expense = 2500
      @monthly_income = 3700
    end

    def expenses
      output = []
      (Date.today..@death_date).each do |mydate|
        output << calculated_expense(mydate) if is_last_day(mydate)
      end
      output
    end

    def income
      output = []
      (Date.today..@death_date).each do |mydate|
        output << calculated_income(mydate) if is_last_day(mydate)
      end
      output
    end

    private

    def is_last_day(mydate)
      mydate.month != mydate.next_day.month
    end

    def calculated_expense(mydate)
      { date: mydate, expense: @monthly_expense*discount_factor(mydate, "expense") }
    end

    def calculated_income(mydate)
      { date: mydate, expense: @monthly_income*discount_factor(mydate, "income") }
    end

    def discount_factor(mydate, type)
      t = (mydate - Date.today)/30
      if type == "expense"
        return ((1 + @inflation_rate/12)/(1 + @portfolio_return/12))**t
      else
        return ((1 + @income_growth_rate/12)/(1 + @portfolio_return/12))**t
      end
    end

  end

end
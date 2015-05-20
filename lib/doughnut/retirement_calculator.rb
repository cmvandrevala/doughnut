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
        output << calculate_present_values(mydate, "expense") if is_last_day(mydate)
      end
      output
    end

    def income
      output = []
      (Date.today..@death_date).each do |mydate|
        output << calculate_present_values(mydate, "income") if is_last_day(mydate)
      end
      output
    end

    def retirement_date
      return Date.today if @monthly_expense == 0
      return @death_date if @monthly_income < @monthly_expense
      e = total_expenses
      c = 0
      income.each do |h|
        date = h[:date]
        c = c + h[:expense]
        return date if c >= e
      end
    end

    def total_expenses
      output = 0
      expenses.each do |h|
        output = output + h[:expense]
      end
      output
    end

    private

    def is_last_day(mydate)
      mydate.month != mydate.next_day.month
    end

    def calculate_present_values(mydate, type)
      if type == "expense"
        return { date: mydate, expense: @monthly_expense*discount_factor(mydate, "expense") }
      else
        return { date: mydate, expense: @monthly_income*discount_factor(mydate, "income") }
      end
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
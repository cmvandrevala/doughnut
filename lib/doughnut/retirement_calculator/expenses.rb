module Doughnut

  class Expenses

    attr_accessor :monthly_expenses, :inflation_rate

    def initialize
      @monthly_expenses = 2500
      @inflation_rate = 0.0322
    end

    def future_expenses(death_date, discount_rate)
      output = []
      (Date.today..death_date).each do |mydate|
        output << present_value(mydate, discount_rate) if is_last_day(mydate)
      end
      output
    end

    def total_expenses(death_date, discount_rate)
      output = 0
      future_expenses(death_date, discount_rate).each do |h|
        output += h[:expense]
      end
      output
    end

    private

    def is_last_day(mydate)
      mydate.month != mydate.next_day.month
    end

    def present_value(mydate, discount_rate)
      { date: mydate, expense: @monthly_expenses*discount_factor(mydate, discount_rate) }
    end

    def discount_factor(mydate, discount_rate)
      t = (mydate - Date.today)/30
      ((1 + @inflation_rate/12)/(1 + discount_rate/12))**t
    end

  end

end
require "doughnut/retirement_calculator/expenses"
require "doughnut/retirement_calculator/income"
require "doughnut/retirement_calculator/retirement_calculator"

task :calculate_retirement do
  e = Expenses.new
  i = Income.new
  r = RetirementCalculator.new
  death_date = r.death_date
  discount_rate = r.portfolio_return
  e_tot = e.total_expenses(death_date, discount_rate)
  i_tot = i.future_income(death_date, discount_rate)
  puts "#{r.retirement_date(e_tot, i_tot)}"
end
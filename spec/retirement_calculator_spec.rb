require "spec_helper"

module Doughnut

  describe RetirementCalculator do

    before(:each) do
      @retire = RetirementCalculator.new
    end

    describe "parameters" do

      context "defaults" do

        it "returns a death date of 80 years old" do
          expect(@retire.death_date).to eq Date.new(2067,7,19)
        end

        it "returns an inflation rate of 3.22%" do
          expect(@retire.inflation_rate).to eq 0.0322
        end

        it "returns an income growth rate of 1%" do
          expect(@retire.income_growth_rate).to eq 0.01
        end

        it "returns average portfolio return of 10%" do
          expect(@retire.portfolio_return).to eq 0.1
        end

        it "returns average monthly expenses of $2500" do
          expect(@retire.monthly_expense).to eq 2500
        end

        it "returns average monthly income of $3700" do
          expect(@retire.monthly_income).to eq 3700
        end

      end

      context "changing parameters" do

        it "updates the death date" do
          @retire.death_date = Date.new(2001,3,7)
          expect(@retire.death_date).to eq Date.new(2001,3,7)
        end

        it "updates the inflation rate" do
          @retire.inflation_rate = 0.005
          expect(@retire.inflation_rate).to eq 0.005
        end

        it "updates the income growth rate" do
          @retire.income_growth_rate = 0.77
          expect(@retire.income_growth_rate).to eq 0.77
        end

        it "updates the average portfolio return" do
          @retire.portfolio_return = 0.99
          expect(@retire.portfolio_return).to eq 0.99
        end

        it "updates the average monthly expenses" do
          @retire.monthly_expense = 52.55
          expect(@retire.monthly_expense).to eq 52.55
        end

        it "updates the average monthly income" do
          @retire.monthly_income = 521.5
          expect(@retire.monthly_income).to eq 521.5
        end

      end

    end

    describe "predicted expenses" do

      context "no inflation" do

        before(:each) do
          @retire.inflation_rate = 0
        end

        it "returns no expenses if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2070,1,1) }
          expect(@retire.expenses).to eq []
        end

        it "returns one expense if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          lower_bound = 0.99696173*2500
          upper_bound = 0.99696174*2500
          expect(@retire.expenses.first[:date]).to eq Date.new(2067,6,30)
          expect(@retire.expenses.first[:expense]).to be > lower_bound
          expect(@retire.expenses.first[:expense]).to be < upper_bound
        end

        it "returns two expenses if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          lower_bound_one = 0.997513455*2500
          upper_bound_one = 0.997513456*2500
          lower_bound_two = 0.989269542*2500
          upper_bound_two = 0.989269543*2500
          expect(@retire.expenses.first[:date]).to eq Date.new(2067,5,31)
          expect(@retire.expenses.last[:date]).to eq Date.new(2067,6,30)
          expect(@retire.expenses.first[:expense]).to be > lower_bound_one
          expect(@retire.expenses.first[:expense]).to be < upper_bound_one
          expect(@retire.expenses.last[:expense]).to be > lower_bound_two
          expect(@retire.expenses.last[:expense]).to be < upper_bound_two
        end

        it "returns many expenses if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          expect(@retire.expenses.length).to eq 90
        end

      end

      context "non-zero inflation" do

        before(:each) do
          @retire.inflation_rate = 0.01
        end

        it "returns no expenses if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2088,1,1) }
          expect(@retire.expenses).to eq []
        end

        it "returns one expense if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,2) }
          lower_bound = 0.99305612*2500
          upper_bound = 0.99305613*2500
          expect(@retire.expenses.first[:date]).to eq Date.new(2067,6,30)
          expect(@retire.expenses.first[:expense]).to be > lower_bound
          expect(@retire.expenses.first[:expense]).to be < upper_bound
        end

        it "returns two expenses if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,25) }
          lower_bound_one = 0.99850795*2500
          upper_bound_one = 0.99850796*2500
          lower_bound_two = 0.99108103*2500
          upper_bound_two = 0.99108104*2500
          expect(@retire.expenses.first[:date]).to eq Date.new(2067,5,31)
          expect(@retire.expenses.last[:date]).to eq Date.new(2067,6,30)
          expect(@retire.expenses.first[:expense]).to be > lower_bound_one
          expect(@retire.expenses.first[:expense]).to be < upper_bound_one
          expect(@retire.expenses.last[:expense]).to be > lower_bound_two
          expect(@retire.expenses.last[:expense]).to be < upper_bound_two
        end

        it "returns many expenses if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          expect(@retire.expenses.length).to eq 90
        end

      end

    end

    describe "predicted income" do

      context "no income growth" do

        before(:each) do
          @retire.income_growth_rate = 0
        end

        it "returns no income if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2075,1,1) }
          expect(@retire.income).to eq []
        end

        it "returns one income if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          lower_bound = 0.99696173*3700
          upper_bound = 0.99696174*3700
          expect(@retire.income.first[:date]).to eq Date.new(2067,6,30)
          expect(@retire.income.first[:expense]).to be > lower_bound
          expect(@retire.income.first[:expense]).to be < upper_bound
        end

        it "returns two incomes if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          lower_bound_one = 0.997513455*3700
          upper_bound_one = 0.997513456*3700
          lower_bound_two = 0.989269542*3700
          upper_bound_two = 0.989269543*3700
          expect(@retire.income.first[:date]).to eq Date.new(2067,5,31)
          expect(@retire.income.last[:date]).to eq Date.new(2067,6,30)
          expect(@retire.income.first[:expense]).to be > lower_bound_one
          expect(@retire.income.first[:expense]).to be < upper_bound_one
          expect(@retire.income.last[:expense]).to be > lower_bound_two
          expect(@retire.income.last[:expense]).to be < upper_bound_two
        end

        it "returns many incomes if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          expect(@retire.income.length).to eq 90
        end

      end

      context "non-zero income growth" do

        before(:each) do
          @retire.income_growth_rate = 0.03
        end

        it "returns no incomes if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2088,1,1) }
          expect(@retire.income).to eq []
        end

        it "returns one income if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,3) }
          lower_bound = 0.99479187*3700
          upper_bound = 0.99479188*3700
          expect(@retire.income.first[:date]).to eq Date.new(2067,6,30)
          expect(@retire.income.first[:expense]).to be > lower_bound
          expect(@retire.income.first[:expense]).to be < upper_bound
        end

        it "returns two incomes if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,25) }
          lower_bound_one = 0.99884028*3700
          upper_bound_one = 0.99884029*3700
          lower_bound_two = 0.99306187*3700
          upper_bound_two = 0.99306188*3700
          expect(@retire.income.first[:date]).to eq Date.new(2067,5,31)
          expect(@retire.income.last[:date]).to eq Date.new(2067,6,30)
          expect(@retire.income.first[:expense]).to be > lower_bound_one
          expect(@retire.income.first[:expense]).to be < upper_bound_one
          expect(@retire.income.last[:expense]).to be > lower_bound_two
          expect(@retire.income.last[:expense]).to be < upper_bound_two
        end

        it "returns many incomes if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          expect(@retire.expenses.length).to eq 90
        end

      end

    end

    describe "retirement date" do

      it "returns today's date if there are no monthly expenses" do
        @retire.monthly_expense = 0
        expect(@retire.retirement_date).to eq Date.today
      end

      it "returns the death date if there is no monthly income" do
        @retire.monthly_income = 0
        expect(@retire.retirement_date).to eq Date.new(2067,7,19)
      end

      it "returns the death date if monthly expenses are greater than monthly income" do
        @retire.monthly_income = 0
        @retire.monthly_expense = 1
        expect(@retire.retirement_date).to eq Date.new(2067,7,19)
      end

      it "returns a date between the current date and the death date" do
        @retire.monthly_income = 2
        @retire.monthly_expense = 1
        expect(@retire.retirement_date).to be > Date.today
        expect(@retire.retirement_date).to be < Date.new(2067,7,19)
      end

    end

    describe "total expenses" do

      it "calculates the total for one expense" do
        @retire.inflation_rate = 0
        allow(Date).to receive(:today) { Date.new(2067,6,19) }
        lower_bound = 0.99696173*2500
        upper_bound = 0.99696174*2500
        expect(@retire.total_expenses).to be > lower_bound
        expect(@retire.total_expenses).to be < upper_bound
      end

      it "calculates the total for two expenses" do
        @retire.inflation_rate = 0
        allow(Date).to receive(:today) { Date.new(2067,5,22) }
        lower_bound = 0.997513455*2500 + 0.989269542*2500
        upper_bound = 0.997513456*2500 + 0.989269543*2500
        expect(@retire.total_expenses).to be > lower_bound
        expect(@retire.total_expenses).to be < upper_bound
      end

    end

  end

end
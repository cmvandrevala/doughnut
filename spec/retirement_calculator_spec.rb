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

        it "returns average portfolio return of 10%" do
          expect(@retire.portfolio_return).to eq 0.1
        end

        it "updates the death date" do
          @retire.death_date = Date.new(2001,3,7)
          expect(@retire.death_date).to eq Date.new(2001,3,7)
        end

        it "updates the average portfolio return" do
          @retire.portfolio_return = 0.99
          expect(@retire.portfolio_return).to eq 0.99
        end

      end

    end

    describe "retirement date" do

      it "returns today's date if there are no monthly expenses or incomes" do
        expect(@retire.retirement_date(0,[])).to eq Date.today
      end

      it "returns today's date if there are no monthly expenses but positive incomes" do
        expect(@retire.retirement_date(0, [{date: Date.new(2012,1,2), income: 100}])).to eq Date.today
      end

      it "returns the death date if there is no monthly income" do
        expect(@retire.retirement_date(1,[])).to eq Date.new(2067,7,19)
      end

      it "returns the date of earned income if PV(income) > PV(expenses)" do
        params = [{:date => Date.new(2040,1,2), :income => 2000}]
        expect(@retire.retirement_date(1000, params)).to eq Date.new(2040,1,2)
      end

      it "returns the date of earned income if PV(income) = PV(expenses)" do
        params = [{:date => Date.new(2041,2,8), :income => 1000}]
        expect(@retire.retirement_date(1000, params)).to eq Date.new(2041,2,8)
      end

      it "returns the date of earned income if PV(income) > PV(expenses) for multiple incomes" do
        params = [{:date => Date.new(2040,1,2), :income => 999}, {:date => Date.new(2049,7,8), :income => 1000}]
        expect(@retire.retirement_date(1000, params)).to eq Date.new(2049,7,8)
      end

      it "returns the date of earned income if PV(income) = PV(expenses) for multiple incomes" do
        params = [{:date => Date.new(2040,1,2), :income => 999}, {:date => Date.new(2049,7,8), :income => 1}]
        expect(@retire.retirement_date(1000, params)).to eq Date.new(2049,7,8)
      end

    end

  end

end
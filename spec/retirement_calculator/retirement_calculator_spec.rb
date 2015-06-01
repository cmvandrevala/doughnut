require "spec_helper"

module Doughnut

  describe RetirementCalculator do

    describe "parameters" do

      before(:each) do
        @retire = RetirementCalculator.new
      end

      context "defaults" do

        it "returns a death date of 80 years old" do
          expect(@retire.death_date).to eq Date.new(2067,7,19)
        end

        it "returns average portfolio return of 10%" do
          expect(@retire.portfolio_return).to eq 0.1
        end

        it "returns a current net worth of 207000" do
          expect(@retire.current_net_worth).to eq 207000
        end

        it "updates the death date" do
          @retire.death_date = Date.new(2001,3,7)
          expect(@retire.death_date).to eq Date.new(2001,3,7)
        end

        it "updates the average portfolio return" do
          @retire.portfolio_return = 0.99
          expect(@retire.portfolio_return).to eq 0.99
        end

        it "updates the current net worth" do
          @retire.current_net_worth = 100
          expect(@retire.current_net_worth).to eq 100
        end

        it "sets the net worth on initialization" do
          worth = RetirementCalculator.new(200).current_net_worth
          expect(worth).to eq 200
        end

      end

    end

    describe "retirement date with no initial net worth" do

      before(:each) do
        @retire = RetirementCalculator.new(0)
      end

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

    describe "retirement date with non-zero initial net worth" do

      before(:each) do
        @retire = RetirementCalculator.new(1000)
      end

      it "returns today's date if there are no monthly expenses or incomes" do
        expect(@retire.retirement_date(0,[])).to eq Date.today
      end

      it "returns today's date if there are no monthly expenses but positive incomes" do
        expect(@retire.retirement_date(0, [{date: Date.new(2011,1,2), income: 100}])).to eq Date.today
      end

      it "returns today's if there is no monthly income, but net worth exceeds expenses" do
        expect(@retire.retirement_date(800,[])).to eq Date.today
      end

      it "returns the death date if there is no monthly income and net worth is less than expenses" do
        expect(@retire.retirement_date(2000,[])).to eq Date.new(2067,7,19)
      end

      it "returns the date of earned income if current_net_worth + PV(income) > PV(expenses) (test 1)" do
        params = [{:date => Date.new(2040,1,2), :income => 2000}]
        expect(@retire.retirement_date(1100, params)).to eq Date.new(2040,1,2)
      end

      it "returns the date of earned income if current_net_worth + PV(income) > PV(expenses) (test 2)" do
        params = [{:date => Date.new(2032,1,5), :income => 980}]
        expect(@retire.retirement_date(1500, params)).to eq Date.new(2032,1,5)
      end

      it "returns the date of earned income if current_net_worth + PV(income) = PV(expenses)" do
        params = [{:date => Date.new(2021,8,8), :income => 1000}]
        expect(@retire.retirement_date(2000, params)).to eq Date.new(2021,8,8)
      end

      it "returns the date of earned income if current_net_worth + PV(income) > PV(expenses) for multiple incomes" do
        params = [{:date => Date.new(2040,1,2), :income => 999}, {:date => Date.new(2049,7,8), :income => 1000}]
        expect(@retire.retirement_date(2500, params)).to eq Date.new(2049,7,8)
      end

      it "returns the date of earned income if current_net_worth + PV(income) = PV(expenses) for multiple incomes" do
        params = [{:date => Date.new(2040,1,2), :income => 999}, {:date => Date.new(2049,7,8), :income => 1}]
        expect(@retire.retirement_date(2000, params)).to eq Date.new(2049,7,8)
      end

    end

  end

end
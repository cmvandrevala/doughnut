require "spec_helper"

module Doughnut

  describe Income do

    before(:each) do
      @income = Income.new
    end

    describe "parameters" do

      it "returns average monthly income of $3700" do
        expect(@income.monthly_income).to eq 3700
      end

      it "updates the average monthly income" do
        @income.monthly_income = 200
        expect(@income.monthly_income).to eq 200
      end

      it "returns an income growth rate of 1%" do
        expect(@income.income_growth_rate).to eq 0.01
      end

      it "updates the income growth rate" do
        @income.income_growth_rate = 0.37
        expect(@income.income_growth_rate).to eq 0.37
      end

    end

    describe "predicted income" do

      context "no income growth" do

        before(:each) do
          @income.income_growth_rate = 0
        end

        it "returns no income if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2075,1,1) }
          expect(@income.future_income(Date.new(2065,1,1), 0.1)).to eq []
        end

        it "returns one date if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income.first[:date]).to eq Date.new(2067,6,30)
        end

        it "returns one income if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          lower_bound = 0.99696173*3700
          upper_bound = 0.99696174*3700
          expect(future_income.first[:income]).to be > lower_bound
          expect(future_income.first[:income]).to be < upper_bound
        end

        it "returns two dates if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income.first[:date]).to eq Date.new(2067,5,31)
          expect(future_income.last[:date]).to eq Date.new(2067,6,30)
        end

        it "returns two incomes if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          lower_bound_one = 0.997513455*3700
          upper_bound_one = 0.997513456*3700
          lower_bound_two = 0.989269542*3700
          upper_bound_two = 0.989269543*3700
          expect(future_income.first[:income]).to be > lower_bound_one
          expect(future_income.first[:income]).to be < upper_bound_one
          expect(future_income.last[:income]).to be > lower_bound_two
          expect(future_income.last[:income]).to be < upper_bound_two
        end

        it "returns many incomes if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income.length).to eq 90
        end

      end

      context "non-zero income growth" do

        before(:each) do
          @income.income_growth_rate = 0.03
        end

        it "returns no incomes if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2088,1,1) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income).to eq []
        end

        it "returns one date if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,3) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income.first[:date]).to eq Date.new(2067,6,30)
        end

        it "returns one income if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,3) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          lower_bound = 0.99479187*3700
          upper_bound = 0.99479188*3700
          expect(future_income.first[:income]).to be > lower_bound
          expect(future_income.first[:income]).to be < upper_bound
        end

        it "returns two dates if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,25) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income.first[:date]).to eq Date.new(2067,5,31)
          expect(future_income.last[:date]).to eq Date.new(2067,6,30)
        end

        it "returns two incomes if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,25) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          lower_bound_one = 0.99884028*3700
          upper_bound_one = 0.99884029*3700
          lower_bound_two = 0.99306187*3700
          upper_bound_two = 0.99306188*3700
          expect(future_income.first[:income]).to be > lower_bound_one
          expect(future_income.first[:income]).to be < upper_bound_one
          expect(future_income.last[:income]).to be > lower_bound_two
          expect(future_income.last[:income]).to be < upper_bound_two
        end

        it "returns many incomes if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          future_income = @income.future_income(Date.new(2067,7,19), 0.1)
          expect(future_income.length).to eq 90
        end

      end

    end

  end

end
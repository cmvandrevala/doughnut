require "spec_helper"

module Doughnut

  describe Expenses do

    before(:each) do
      @expenses = Expenses.new
    end

    describe "parameters" do

      it "returns average monthly expenses of $2500" do
        expect(@expenses.monthly_expenses).to eq 2500
      end

      it "updates the average monthly expenses" do
        @expenses.monthly_expenses = 52.55
        expect(@expenses.monthly_expenses).to eq 52.55
      end

      it "returns an inflation rate of 3.22%" do
        expect(@expenses.inflation_rate).to eq 0.0322
      end

      it "updates the average inflation rate" do
        @expenses.inflation_rate = 0.112
        expect(@expenses.inflation_rate).to eq 0.112
      end

    end

    describe "predicted expenses" do

      context "no inflation" do

        before(:each) do
          @expenses.inflation_rate = 0
        end

        it "returns no expenses if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2070,1,1) }
          expect(@expenses.future_expenses(Date.new(2065,1,1), 0.1)).to eq []
        end

        it "returns one date if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          future_expenses = @expenses.future_expenses(Date.new(2067,7,19), 0.1)
          expect(future_expenses.first[:date]).to eq Date.new(2067,6,30)
        end

        it "returns one expense if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          future_expenses = @expenses.future_expenses(Date.new(2067,7,19), 0.1)
          lower_bound = 0.99696173*2500
          upper_bound = 0.99696174*2500
          expect(future_expenses.first[:expense]).to be > lower_bound
          expect(future_expenses.first[:expense]).to be < upper_bound
        end

        it "returns two dates if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          future_expenses = @expenses.future_expenses(Date.new(2067,7,19), 0.1)
          expect(future_expenses.first[:date]).to eq Date.new(2067,5,31)
          expect(future_expenses.last[:date]).to eq Date.new(2067,6,30)
        end

        it "returns two expenses if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          future_expenses = @expenses.future_expenses(Date.new(2067,7,19), 0.1)
          lower_bound_one = 0.997513455*2500
          upper_bound_one = 0.997513456*2500
          lower_bound_two = 0.989269542*2500
          upper_bound_two = 0.989269543*2500
          expect(future_expenses.first[:expense]).to be > lower_bound_one
          expect(future_expenses.first[:expense]).to be < upper_bound_one
          expect(future_expenses.last[:expense]).to be > lower_bound_two
          expect(future_expenses.last[:expense]).to be < upper_bound_two
        end

        it "returns many expenses if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).length).to eq 90
        end

      end

      context "non-zero inflation" do

        before(:each) do
          @expenses.inflation_rate = 0.01
        end

        it "returns no expenses if the death date has passed" do
          allow(Date).to receive(:today) { Date.new(2088,1,1) }
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1)).to eq []
        end

        it "returns one expense if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,2) }
          lower_bound = 0.99305612*2500
          upper_bound = 0.99305613*2500
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).first[:expense]).to be > lower_bound
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).first[:expense]).to be < upper_bound
        end

        it "returns one date if there is only one month to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,6,2) }
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).first[:date]).to eq Date.new(2067,6,30)
        end

        it "returns two dates if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,25) }
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).first[:date]).to eq Date.new(2067,5,31)
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).last[:date]).to eq Date.new(2067,6,30)
        end

        it "returns two expenses if there are two months to the death date" do
          allow(Date).to receive(:today) { Date.new(2067,5,25) }
          lower_bound_one = 0.99850795*2500
          upper_bound_one = 0.99850796*2500
          lower_bound_two = 0.99108103*2500
          upper_bound_two = 0.99108104*2500
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).first[:expense]).to be > lower_bound_one
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).first[:expense]).to be < upper_bound_one
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).last[:expense]).to be > lower_bound_two
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).last[:expense]).to be < upper_bound_two
        end

        it "returns many expenses if there are many months up to the death date" do
          allow(Date).to receive(:today) { Date.new(2060,1,2) }
          expect(@expenses.future_expenses(Date.new(2067,7,19), 0.1).length).to eq 90
        end

      end

      describe "total expenses" do

        it "calculates the total for one expense" do
          @expenses.inflation_rate = 0
          allow(Date).to receive(:today) { Date.new(2067,6,19) }
          lower_bound = 0.99696173*2500
          upper_bound = 0.99696174*2500
          expect(@expenses.total_expenses(Date.new(2067,7,19), 0.1)).to be > lower_bound
          expect(@expenses.total_expenses(Date.new(2067,7,19), 0.1)).to be < upper_bound
        end

        it "calculates the total for two expenses" do
          @expenses.inflation_rate = 0
          allow(Date).to receive(:today) { Date.new(2067,5,22) }
          lower_bound = 0.997513455*2500 + 0.989269542*2500
          upper_bound = 0.997513456*2500 + 0.989269543*2500
          expect(@expenses.total_expenses(Date.new(2067,7,19), 0.1)).to be > lower_bound
          expect(@expenses.total_expenses(Date.new(2067,7,19), 0.1)).to be < upper_bound
        end

      end

    end


  end

end
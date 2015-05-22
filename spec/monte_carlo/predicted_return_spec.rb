require "spec_helper"
require "descriptive_statistics"

module Doughnut

  describe PredictedReturn do

    describe "#return" do

      context "boundary conditions" do

        it "gives zero predicted return if there are no inputs" do
          expect(PredictedReturn.new.return).to eq 0
        end

        it "gives zero predicted return if both average return and standard deviation are zero" do
          expect(PredictedReturn.new(0,0).return).to eq 0
        end

        it "gives the average return if standard deviation is zero" do
          expect(PredictedReturn.new(0.5,0).return).to eq 0.5
        end

        it "gives a range of returns if the standard deviation is zero" do
          expect(PredictedReturn.new(0,0.0001).return).to be > -1
          expect(PredictedReturn.new(0,0.0001).return).to be < 1
        end

      end

      context "Gaussian outputs" do

        before(:each) do
          @simulation = PredictedReturn.new(0.4, 0.1)
          @thin_sim = PredictedReturn.new(0.8, 0.00000000001)
        end

        it "the data points should be unique" do
          output = []
          50.times { output << @simulation.return }
          expect(output.uniq.length).to eq 50
        end

        it "the data points should have the given mean" do
          output = []
          50.times { output << @simulation.return }
          expect(output.mean).to be > 0.25
          expect(output.mean).to be < 0.45
        end

        it "the data points should have the given standard deviation" do
          output = []
          50.times { output << @simulation.return }
          expect(output.standard_deviation).to be > 0.0
          expect(output.standard_deviation).to be < 0.2
        end

        it "creates data points near the average return if the standard deviation is small" do
          output = []
          50.times { output << @thin_sim.return }
          expect(output.mean).to be > 0.7999
          expect(output.mean).to be < 0.8001
        end

        it "creates closely clustered data points if the standard deviation is small" do
          output = []
          50.times { output << @thin_sim.return }
          expect(output.standard_deviation).to be > 0.0000
          expect(output.standard_deviation).to be < 0.0002
        end

      end

    end

  end

end
require "spec_helper"

module Doughnut

  describe PopulationTester do

    it "returns no population if it is given no input" do
      t = PopulationTester.new
      expect(t.compete).to eq []
    end

  end

end
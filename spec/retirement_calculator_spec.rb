require "spec_helper"

module Doughnut

  describe RetirementCalculator do

    describe "risk free rate" do
      it "retrieves the risk free interest rate from Yahoo Finance"
      it "uses a default rate if Yahoo cannot be accessed"
    end

    describe "broad market rate" do
      it "estimates a broad market rate based on historical data"
    end

    describe "beta" do
      it "calculates beta for two correlated assets"
      it "calculates beta for two uncorrelated assets"
      it "calculates beta for two random assets"
    end

    describe "beta" do
      it "calculates beta for two correlated assets"
      it "calculates beta for two uncorrelated assets"
      it "calculates beta for two random assets"
    end

  end

end
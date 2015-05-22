require "spec_helper"

module Doughnut

  describe Population do

    describe "building a population of random genomes" do

      context "one input" do

        before(:each) do
          @population = Population.new( [{name: "X", avg_return: 1, standard_deviation: 5}] ).build_random_population
        end

        it "returns ten genomes" do
          expect(@population.length).to eq 10
        end

        it "each genome has a length equal to one" do
          @population.each do |genome|
            expect(genome.length).to eq 1
          end
        end

        it "each gene in a given genome has a name" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:name]).not_to be nil
            end
          end
        end

        it "each gene in a given genome has an average return" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:avg_return]).to eq 1
            end
          end
        end

        it "each gene in a given genome has a standard deviation" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:standard_deviation]).to eq 5
            end
          end
        end

        it "each gene in a given genome has a fraction of one" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:fraction]).to eq 1
            end
          end
        end

      end

      context "multiple inputs" do

        before(:each) do
          @population = Population.new( [{name: "X", avg_return: 1, standard_deviation: 5},{name: "Y", avg_return: 3, standard_deviation: 7}] ).build_random_population
        end

        it "returns ten genomes" do
          expect(@population.length).to eq 10
        end

        it "each genome has a length greater than one" do
          @population.each do |genome|
            expect(genome.length).to eq 2
          end
        end

        it "each gene in a given genome has a name" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:name]).not_to be nil
            end
          end
        end

        it "each gene in a given genome has an average return" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:avg_return] == 1 || gene[:avg_return] == 3).to be true
            end
          end
        end

        it "each gene in a given genome has a standard deviation" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:standard_deviation] == 5 || gene[:standard_deviation] == 7).to be true
            end
          end
        end

        it "each fraction is NOT equal to one" do
          @population.each do |genome|
            genome.each do |gene|
              expect(gene[:fraction]).not_to eq 1
            end
          end
        end

        it "the sum of all fractions equals one" do
          @population.each do |genome|
            sum = 0
            genome.each { |gene| sum += gene[:fraction] }
            expect(sum).to eq 1
          end
        end

      end

    end

  end

end

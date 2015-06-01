module Doughnut

  class PopulationFactory

    def initialize(list_of_assets)
      @num_genomes = 10
      @list_of_assets = list_of_assets
    end

    def build_random_population
      Array.new(@num_genomes, random_genome)
    end

    private

    def random_genome
      output = []
      @list_of_assets.each_with_index do |asset, indx|
        output << asset.merge!({fraction: gene_fractions[indx]})
      end
    end

    def gene_fractions
      fracs = Array.new(@list_of_assets.length, rand)
      s = fracs.sum
      fracs.map { |x| x/s }
    end

  end

end
module AoC2023
  module Day05

    def self.parse_mappings(chunks)
      mappings = chunks.map { |chunk| parse_dest_src_map(chunk.split("\n").map(&:strip)) }
      {
        seed_to_soil: mappings[0],
        soil_to_fertilizer: mappings[1],
        fertilizer_to_water: mappings[2],
        water_to_light: mappings[3],
        light_to_temperature: mappings[4],
        temperature_to_humidity: mappings[5],
        humidity_to_location: mappings[6]
      }
    end

    def self.parse_dest_src_map(map)
      range_specs = map[1..-1].map { |line| line.split(" ").map(&:to_i) }
  
      result = range_specs.map do |spec|
        dest, src, length = spec
        { dest: [dest, dest + length - 1], src: [src, src + length - 1] }
      end

      result
    end

    def self.find_match_or_identity(mapping, token, from:, to:)
      range = mapping.find do |ranges|
        dest_range = ranges[from]
        dest_range.first <= token && token <= dest_range.last
      end

      return token unless range

      range[to].first + token - range[from].first
    end

    module Part01
      def self.solve(input:)
        mappings = parse_input(input)
        seeds = mappings[:seeds]
        locations = seeds.map { |seed| find_location_for_seed(mappings, seed: seed) }

        locations.min
      end
  
      def self.find_location_for_seed(mappings, seed:)
        soil = find_match_or_identity(mappings[:seed_to_soil], token: seed)
        fertilizer = find_match_or_identity(mappings[:soil_to_fertilizer], token: soil)
        water = find_match_or_identity(mappings[:fertilizer_to_water], token: fertilizer)
        light = find_match_or_identity(mappings[:water_to_light], token: water)
        temperature = find_match_or_identity(mappings[:light_to_temperature], token: light)
        humidity = find_match_or_identity(mappings[:temperature_to_humidity], token: temperature)
        location = find_match_or_identity(mappings[:humidity_to_location], token: humidity)
  
        location
      end
  
      def self.find_match_or_identity(mapping, token:)
        Day05.find_match_or_identity(mapping, token, from: :src, to: :dest)
      end

      def self.parse_input(input)
        chunks = input.strip.split("\n\n").map(&:strip)
        raw_seeds = chunks.first.split("\n").map(&:strip)
        seeds = parse_seeds(raw_seeds)
        mappings = Day05.parse_mappings(chunks.slice(1, chunks.size - 1))

        { seeds: seeds }.merge(mappings)
      end

      def self.parse_seeds(raw_seeds) 
        raw_seeds.first.split(":").last.strip.split(" ").map(&:to_i)
      end
    end

    module Part02
      def self.solve(input:)
        mappings = parse_input(input)
        seed_ranges = mappings[:seeds]

        found_location = nil

        while found_location.nil?
          (0..Float::INFINITY).each do |location|
            seed = find_seed_for_location(mappings, location: location)
            found_location = location if seed_ranges.any? { |range| range.include?(seed) }
            break if found_location
          end
        end

        found_location
      end

      def self.parse_input(input)
        chunks = input.strip.split("\n\n").map(&:strip)
        raw_seeds = chunks.first.split("\n").map(&:strip)
        seeds = parse_seeds(raw_seeds)
        mappings = Day05.parse_mappings(chunks.slice(1, chunks.size - 1))

        { seeds: seeds }.merge(mappings)
      end

      def self.parse_seeds(raw_seeds) 
        numbers = raw_seeds.first.split(":").last.strip.split(" ").map(&:to_i)
        ranges = []

        while numbers.any?
          init, size = numbers.shift(2)
          ranges << (init..init + size - 1)
        end

        ranges
      end

      def self.find_src_or_identity(mapping, token:)
        Day05.find_match_or_identity(mapping, token, from: :dest, to: :src)
      end

      def self.find_seed_for_location(mappings, location:)
        humidity = find_src_or_identity(mappings[:humidity_to_location], token: location)
        temperature = find_src_or_identity(mappings[:temperature_to_humidity], token: humidity)
        light = find_src_or_identity(mappings[:light_to_temperature], token: temperature)
        water = find_src_or_identity(mappings[:water_to_light], token: light)
        fertilizer = find_src_or_identity(mappings[:fertilizer_to_water], token: water)
        soil = find_src_or_identity(mappings[:soil_to_fertilizer], token: fertilizer)
        seed = find_src_or_identity(mappings[:seed_to_soil], token: soil)

        seed
      end
    end
  end
end

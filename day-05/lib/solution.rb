module AoC2023
  module Day05

    module Part01
      def self.solve(input:)
        mappings = parse_input(input)
        seeds = mappings[:seeds]

        seeds.map { |seed| find_location_for_seed(mappings, seed: seed) }.min
      end

      def self.parse_dest_src_map(map)
        range_specs = map[1..-1].map { |line| line.split(" ").map(&:to_i) }
  
        result = range_specs.map do |spec|
          dest, src, length = spec
          [(dest..dest + length - 1), (src..src + length - 1)]
        end
  
        result
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
        range = mapping.find.with_index do |ranges|
          _, src_range = ranges
          src_range.include?(token)
        end
  
        return token unless range
  
        dest_range, src_range = range
        dest_range.begin + token - src_range.begin
      end

      def self.parse_input(input)
        first_stage = input.strip.split("\n\n").map(&:strip)
        raw_seeds, seed_to_soil_map, soil_to_fertilizer_map, fertilizer_to_water_map,
          water_to_light_map, light_to_temperature_map, temperature_to_humidity_map,
          humidity_to_location_map = first_stage.map { |stage| stage.split("\n").map(&:strip) }

        seeds = parse_seeds(raw_seeds)
        seed_to_soil, soil_to_fertilizer, fertilizer_to_water, water_to_light,
          light_to_temperature, temperature_to_humidity, humidity_to_location = [
          parse_dest_src_map(seed_to_soil_map),
          parse_dest_src_map(soil_to_fertilizer_map),
          parse_dest_src_map(fertilizer_to_water_map),
          parse_dest_src_map(water_to_light_map),
          parse_dest_src_map(light_to_temperature_map),
          parse_dest_src_map(temperature_to_humidity_map),
          parse_dest_src_map(humidity_to_location_map)
        ]

        {
          seeds: seeds,
          seed_to_soil: seed_to_soil,
          soil_to_fertilizer: soil_to_fertilizer,
          fertilizer_to_water: fertilizer_to_water,
          water_to_light: water_to_light,
          light_to_temperature: light_to_temperature,
          temperature_to_humidity: temperature_to_humidity,
          humidity_to_location: humidity_to_location
        }
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
        first_stage = input.strip.split("\n\n").map(&:strip)
        raw_seeds, seed_to_soil_map, soil_to_fertilizer_map, fertilizer_to_water_map,
          water_to_light_map, light_to_temperature_map, temperature_to_humidity_map,
          humidity_to_location_map = first_stage.map { |stage| stage.split("\n").map(&:strip) }

        seeds = Part02.parse_seeds(raw_seeds)
        seed_to_soil, soil_to_fertilizer, fertilizer_to_water, water_to_light,
          light_to_temperature, temperature_to_humidity, humidity_to_location = [
          parse_dest_src_map(seed_to_soil_map),
          parse_dest_src_map(soil_to_fertilizer_map),
          parse_dest_src_map(fertilizer_to_water_map),
          parse_dest_src_map(water_to_light_map),
          parse_dest_src_map(light_to_temperature_map),
          parse_dest_src_map(temperature_to_humidity_map),
          parse_dest_src_map(humidity_to_location_map)
        ]

        {
          seeds: seeds,
          seed_to_soil: seed_to_soil,
          soil_to_fertilizer: soil_to_fertilizer,
          fertilizer_to_water: fertilizer_to_water,
          water_to_light: water_to_light,
          light_to_temperature: light_to_temperature,
          temperature_to_humidity: temperature_to_humidity,
          humidity_to_location: humidity_to_location
        }
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

      def self.parse_dest_src_map(map)
        range_specs = map[1..-1].map { |line| line.split(" ").map(&:to_i) }
  
        result = range_specs.map do |spec|
          dest, src, length = spec
          { dest: [dest, dest + length - 1], src: [src, src + length - 1] }
        end
  
        result
      end

      def self.find_dest_or_identity(mapping, token:)
        range = mapping.find do |ranges|
          src_range = ranges[:src]
          src_range.first <= token && token <= src_range.last
        end

        return token unless range
  
        range[:dest].first + token - range[:src].first
      end

      def self.find_src_or_identity(mapping, token:)
        range = mapping.find do |ranges|
          dest_range = ranges[:dest]
          dest_range.first <= token && token <= dest_range.last
        end

        return token unless range
  
        range[:src].first + token - range[:dest].first
      end

      def self.find_location_for_seed(mappings, seed:)
        soil = find_dest_or_identity(mappings[:seed_to_soil], token: seed)
        fertilizer = find_dest_or_identity(mappings[:soil_to_fertilizer], token: soil)
        water = find_dest_or_identity(mappings[:fertilizer_to_water], token: fertilizer)
        light = find_dest_or_identity(mappings[:water_to_light], token: water)
        temperature = find_dest_or_identity(mappings[:light_to_temperature], token: light)
        humidity = find_dest_or_identity(mappings[:temperature_to_humidity], token: temperature)
        location = find_dest_or_identity(mappings[:humidity_to_location], token: humidity)
  
        location
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

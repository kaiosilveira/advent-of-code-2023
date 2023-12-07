module AoC2023
  module Day06
    module Part01
      def self.solve(input:)
        get_product_of_record_breaking_possibilities(
          records: parse_input(boat_race_records: input)
        )
      end

      def self.get_product_of_record_breaking_possibilities(records:)
        records.map do |record|
          distributions = get_possible_acceleration_distributions_for(record: record)
          record_breaking_distributions = get_record_breaking_acceleration_distributions(
            target_distance: record[:distance],
            distributions: distributions
          )
          record_breaking_distributions.size
        end.reduce(&:*)
      end

      def self.get_record_breaking_acceleration_distributions(target_distance:, distributions:)
        distributions.select { |distribution| distribution[:total_distance] > target_distance }
      end

      def self.get_possible_acceleration_distributions_for(record:)
        (1..record[:time] - 1).map.with_index do |acceleration, idx|
          available_time = record[:time] - acceleration
          { acceleration: acceleration, total_distance: available_time * acceleration }
        end
      end

      def self.parse_input(boat_race_records:)
        records = boat_race_records
          .map { |record| record.split(":")[1] }
          .map { |record| record.split(" ").map(&:to_i) }
          .transpose
          .map { |record| { time: record[0], distance: record[1] } }

          records
      end
    end

    module Part02
      def self.solve(input:)
        record = parse_input(input: input)
        get_number_of_record_breaking_acceleration_distributions_for(record: record)
      end

      def self.parse_input(input:)
        time, distance = input.map { |record| record.split(":")[1].split(' ').join.to_i }
        { time: time, distance: distance }
      end

      def self.get_number_of_record_breaking_acceleration_distributions_for(record:)
        time_range = (1..record[:time] - 1)

        record_breaking_range = [
          get_first_acceleration_that_breaks_record(time_range: time_range, record: record),
          get_first_acceleration_that_breaks_record(
            time_range: time_range.last.downto(time_range.first), record: record
          )
        ]

        range_start = time_range.begin + record_breaking_range.first
        range_end = time_range.end - record_breaking_range.last

        range_end - range_start + 1
      end

      def self.get_first_acceleration_that_breaks_record(time_range:, record:)
        time_range.each.with_index do |acceleration, idx|
          available_time = record[:time] - acceleration
          total_distance = available_time * acceleration
          breaks_record = total_distance > record[:distance]
          return idx if breaks_record
        end
      end
    end
  end
end

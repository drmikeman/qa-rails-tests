# frozen_string_literal: true

module Policies
  class BedCountPolicy
    QUEEN = "queen"
    KING = "king"
    DOUBLE = "double"

    def initialize(room_info)
      @room_info = room_info
    end

    def all_bed_count
      bed_counts.values.sum
    end

    def bed_counts
      @bed_counts ||= calculate_bed_counts
    end

    private

    attr_reader :room_info

    def calculate_bed_counts
      room_info[:bed_details].each_with_object(Hash.new(0)) do |bed_info, bed_counts|
        bed_type = bed_info["type"].downcase.remove("bed")
        bed_counts[bed_type] += bed_info["count"] if bed_types.include?(bed_type)
      end
    end

    def bed_types
      @bed_types ||= [KING, QUEEN].tap do |bed_types|
        bed_types.push(DOUBLE) unless room_info[:country] == "US"
      end.flatten
    end
  end
end

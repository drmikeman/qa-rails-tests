# frozen_string_literal: true

module Policies
  class RoomStatusPolicy
    BUNK_BED = "bunk"

    NON_SMOKING_REGEX = /non?[- ]?smo?k/

    def initialize(room_info)
      @room_info = room_info
    end

    def disablers
      [].tap do |disablers|
        disablers.push(:smoking) if smoking?
        disablers.push(:bunk_bed) if bunk_bed?
      end
    end

    private

    attr_reader :room_info

    def smoking?
      smoking_indicator = room_info[:smoking_indicator]
      return true if smoking_indicator == :smoking
      return false if smoking_indicator == :nonsmoking

      !(room_info[:name].match(NON_SMOKING_REGEX) || room_info[:description]&.match(NON_SMOKING_REGEX))
    end

    def bunk_bed?
      room_info[:bed_details].any? { |bed_info| bed_info["type"].downcase == BUNK_BED }
    end
  end
end

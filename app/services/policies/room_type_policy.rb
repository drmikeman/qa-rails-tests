# frozen_string_literal: true

module Policies
  class RoomTypePolicy
    def initialize(gateway_room_type, country)
      @gateway_room_type = gateway_room_type
      @country = country
    end

    def htx_room_type
      log_room_type_info

      return nil unless room_enabled?
      return :one_bed if bed_count == 1
      return :two_beds if bed_count >= 2

      nil
    end

    private

    attr_reader :gateway_room_type, :country

    def room_enabled?
      @room_enabled ||= room_status_policy.disablers.empty?
    end

    def bed_count
      @bed_count ||= bed_count_policy.all_bed_count
    end

    def room_status_policy
      @room_status_policy ||= RoomStatusPolicy.new(room_info)
    end

    def bed_count_policy
      @bed_count_policy ||= BedCountPolicy.new(room_info)
    end

    def room_info
      @room_info ||= {
        name: gateway_room_type["name"].downcase,
        description: gateway_room_type["desc"]&.downcase,
        bed_details: Array(gateway_room_type["bedDetails"]),
        smoking_indicator: gateway_room_type["smokingIndicator"].downcase.to_sym,
        country: country,
      }
    end

    def log_room_type_info
      type = gateway_room_type["roomTypeCode"]
      disablers = room_status_policy.disablers
      beds = bed_count_policy.bed_counts
      count = bed_count_policy.all_bed_count
      Rails.logger.info("[#{self.class.name}][#{type}] disablers: #{disablers} beds(#{count}): #{beds}")
    end
  end
end

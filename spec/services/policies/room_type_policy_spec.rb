# frozen_string_literal: true

require "rails_helper"

describe Policies::RoomTypePolicy do
  let(:room_type) do
    {
      "name" => "Blue deluxe room",
      "type" => "Deluxe room",
      "desc" => "<strong>1 queen bed</strong><strong>bathroom</strong>",
      "bedDetails" => [{ "type" => "Queen", "count" => 1 }],
      "smokingIndicator" => "NonSmoking",
    }
  end

  it "returns nil if there are some status disablers" do
    room_status_double = instance_double(Policies::RoomStatusPolicy, disablers: [:smoking])
    expect(Policies::RoomStatusPolicy).to receive(:new).and_return(room_status_double)

    room_type_policy = described_class.new(room_type, "US")
    expect(room_type_policy.htx_room_type).to be_nil
  end

  it "returns nil if there are no proper beds" do
    allow(Policies::RoomStatusPolicy).to receive(:new).and_return(double(disablers: []))

    bed_count_double = instance_double(Policies::BedCountPolicy, bed_counts: [], all_bed_count: 0)
    expect(Policies::BedCountPolicy).to receive(:new).and_return(bed_count_double)

    room_type_policy = described_class.new(room_type, "US")
    expect(room_type_policy.htx_room_type).to be_nil
  end

  it "returns '1 bed' if there is one proper bed" do
    allow(Policies::RoomStatusPolicy).to receive(:new).and_return(double(disablers: []))

    bed_count_double = instance_double(Policies::BedCountPolicy, bed_counts: [], all_bed_count: 1)
    expect(Policies::BedCountPolicy).to receive(:new).and_return(bed_count_double)

    room_type_policy = described_class.new(room_type, "US")
    expect(room_type_policy.htx_room_type).to eq(:one_bed)
  end

  it "returns '2 beds' if there are more than one proper beds" # TODO

  context "integration test" do
    it "returns '2 beds' if there are more than one proper beds" # TODO
  end
end

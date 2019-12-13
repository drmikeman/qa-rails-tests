# frozen_string_literal: true

require "rails_helper"

describe Policies::BedCountPolicy do
  let(:room_info) do
    { bed_details: [], country: "DE" }
  end

  it "returns empty array for the empty or invalid array" do
    policy = described_class.new(room_info.merge(bed_details: []))
    expect(policy.bed_counts.empty?).to be(true)
    expect(policy.all_bed_count).to eq(0)
  end

  it "return empty array for bed types not allowed in US" # TODO

  it "return proper number of double beds in other country then US" do
    bed_details = [{ "type" => "Double", "count" => 2 }]
    policy = described_class.new(room_info.merge(bed_details: bed_details, country: "DE"))
    expect(policy.bed_counts).to eq("double" => 2)
    expect(policy.all_bed_count).to eq(2)
  end

  it "return proper number of beds in a room with various beds" do
    bed_details = [{ "type" => "King", "count" => 2 }, { "type" => "Queen", "count" => 1 }]
    policy = described_class.new(room_info.merge(bed_details: bed_details))
    expect(policy.bed_counts).to eq("queen" => 1, "king" => 2)
    expect(policy.all_bed_count).to eq(3)
  end

  it "returns proper number of beds for a type with the 'bed' suffix" do
    bed_details = [{ "type" => "KingBed", "count" => 2 }]
    policy = described_class.new(room_info.merge(bed_details: bed_details))
    expect(policy.bed_counts).to eq("king" => 2)
    expect(policy.all_bed_count).to eq(2)
  end
end

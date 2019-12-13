# frozen_string_literal: true

require "rails_helper"

describe Policies::RoomStatusPolicy do
  let(:room_info) do
    { smoking_indicator: :nonsmoking, name: "double room", description: nil, bed_details: [] }
  end

  it "advises disabling smoking room" do
    policy = described_class.new(room_info.merge(smoking_indicator: :smoking))
    expect(policy.disablers).to include(:smoking)
  end

  it "advises not disabling nonsmoking room" # TODO

  it "advises not disabling room with unknown indicator and non-smoking phrase in name or description" do
    policy = described_class.new(room_info.merge(smoking_indicator: :unknown, description: "a double room nosmk"))
    expect(policy.disablers).not_to include(:smoking)
  end

  it "advises disabling room with unknown indicator and additional information in name or description" # TODO

  it "advises disabling room with bunk bed" do
    bed_details = [{ "type" => "Queen", "count" => 2 }, { "type" => "bunk", "count" => 1 }]
    policy = described_class.new(room_info.merge(bed_details: bed_details))
    expect(policy.disablers).to include(:bunk_bed)
  end
end

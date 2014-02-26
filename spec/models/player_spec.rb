require 'spec_helper'

describe Player do
  context "validations" do
    it { should validate_presence_of :phone_number }
  end

  context "associations" do
    it { should belong_to(:game) }
  end
end
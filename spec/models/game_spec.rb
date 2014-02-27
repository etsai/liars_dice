require 'spec_helper'

describe Game do
  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_unquieness_of :name }
  end

  context "associations" do
    it { should have_many :players }
  end

end
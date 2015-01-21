require 'rails_helper'

RSpec.describe TagRelationship, :type => :model do
  it { should validate_presence_of(:tag) }
  it { should validate_presence_of(:question) }
end

require 'rails_helper'

RSpec.describe TagRelationship, :type => :model do
  it { should validate_presence_of(:tag_id) }
  it { should validate_presence_of(:question_id) }
end

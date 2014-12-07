require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it { should ensure_length_of(:body).is_at_most(10000) }

  it { should belong_to(:question) }
end

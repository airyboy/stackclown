require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it { should ensure_length_of(:body).is_at_most(GlobalConstants::ANSWER_BODY_MAX_LENGTH) }

  it { should belong_to(:question) }

  describe 'comments association' do
    it { should have_many(:comments) }
  end
end

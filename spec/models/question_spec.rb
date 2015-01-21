require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should have_many(:attachments) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should have_many(:tags) }
  it { should belong_to(:user) }
  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :tags_comma_separated }

  it { should ensure_length_of(:title).is_at_most(GlobalConstants::QUESTION_TITLE_MAX_LENGTH) }
  it { should ensure_length_of(:body).is_at_most(GlobalConstants::QUESTION_BODY_MAX_LENGTH) }
end

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:commentable_id) }
  it { should ensure_length_of(:body).is_at_most(1000) }

  describe "question association" do
    let(:question) { FactoryGirl.create(:question) }
    before { @comment = question.comments.create(body:"Comment") }

    it "should have right comment" do
      expect(question.comments.first).to eq @comment
    end

    it "should have right question" do
      expect(@comment.commentable).to eq question
    end
  end

  describe "answer association" do
    let(:answer) { FactoryGirl.create(:question) }
    before { @comment = answer.comments.create(body:"Comment") }

    it "should have right answer" do
      expect(answer.comments.first).to eq @comment
    end

    it "should have right answer" do
      expect(@comment.commentable).to eq answer
    end
  end
end

require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should ensure_length_of(:title).is_at_most(30) }
  it { should ensure_length_of(:body).is_at_most(1000) }
  
  let!(:question) { FactoryGirl.create(:question) }

  describe 'answer association' do
    it { should have_many(:answers) }

    
    let!(:old_answer) { FactoryGirl.create(:answer, question: question, body: 'Old answer', created_at: 1.month.ago)  }
    let!(:newer_answer) { FactoryGirl.create(:answer, question:question, body: 'New answer', created_at: 1.day.ago)  }

    it "should have answers in the right order" do
      expect(question.answers.to_a).to eq [old_answer, newer_answer]
    end
  end

  describe 'comments association' do
    it { should have_many(:comments) }
  end

  describe 'tags association' do
    it { should have_many(:tags) }

    let(:tag) { FactoryGirl.create(:tag) }

    it 'should assign a tag' do
      before { question.assign_tag(tag) }

      expect(question.tags).to include(tag)
    end

    it 'should create a tag with a new name' do
      @new_tag = "new"
      expect(question.assign_tag(@new_tag).to change(question.tags, :count).by(1))
    end

    it 'should not be able to assign the same tag twice' do

    end
  end
end

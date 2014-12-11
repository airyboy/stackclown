require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should ensure_length_of(:title).is_at_most(GlobalConstants::QUESTION_TITLE_MAX_LENGTH) }
  it { should ensure_length_of(:body).is_at_most(GlobalConstants::QUESTION_BODY_MAX_LENGTH) }
  
  let!(:question) { FactoryGirl.create(:question) }

  describe 'answer association' do
    it { should have_many(:answers) }

    
    let!(:old_answer) { FactoryGirl.create(:answer, question: question, body: 'Old answer', created_at: 1.month.ago)  }
    let!(:newer_answer) { FactoryGirl.create(:answer, question:question, body: 'New answer', created_at: 1.day.ago)  }

    it 'should have answers in the right order' do
      expect(question.answers.to_a).to eq [old_answer, newer_answer]
    end
  end

  describe 'comments association' do
    it { should have_many(:comments) }

    let!(:new_comment) { FactoryGirl.create(:comment, commentable: question, created_at: 1.hour.ago) }
    let!(:old_comment) { FactoryGirl.create(:comment, commentable: question, created_at: 1.day.ago) }

    it 'should have comments in the right order' do
      expect(question.comments.to_a).to eq [old_comment, new_comment]
    end
  end

  describe 'tags association' do
    it { should have_many(:tags) }

    let(:tag) { FactoryGirl.create(:tag) }

    before do
      @tag = 'tag-text'
      Tag.create(tag_name: @tag)
    end

    context 'when assigning a new tag' do
      before { @new_tag = 'new-tag-text' }
      it 'should create a tag with a new name' do
        expect{ question.assign_tag(@new_tag) }.to change(question.tags, :count).by(1)
      end
    end

    context 'when assigning an existing tag' do
      before { @the_tag = question.assign_tag(@tag) }

      it 'should assign this tag' do
        expect(question.tags).to include(@the_tag)
      end

      it 'should not assign the same tag twice' do
        expect{ question.assign_tag(@tag) }.not_to change(question.tags, :count)
      end
    end

    context 'when removing the tag' do
      before { question.tags << tag }

      it 'should remove this tag from the question' do
        expect{ question.remove_tag(tag) }.to change(question.tags, :count).by(-1)
      end


    end
  end
end

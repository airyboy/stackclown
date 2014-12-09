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

    it 'should have answers in the right order' do
      expect(question.answers.to_a).to eq [old_answer, newer_answer]
    end
  end

  describe 'comments association' do
    it { should have_many(:comments) }
  end

  describe 'tags association' do
    it { should have_many(:tags) }

    before do
      Tag.create(tag_name: 'tag-text')
      @tag = 'tag-text'
    end

    describe 'when assigning an existing tag' do
      before { @the_tag = question.assign_tag(@tag) }

      it 'should assign this tag' do
        expect(question.tags).to include(@the_tag)
      end

      it 'should not assign the same tag twice' do
        expect{ question.assign_tag(@tag) }.not_to change(question.tags, :count)
      end
    end

    describe 'when assigning a new tag' do
      before { @new_tag = 'new-tag-text' }
      it 'should create a tag with a new name' do
        expect{ question.assign_tag(@new_tag) }.to change(question.tags, :count).by(1)
      end
    end
  end
end

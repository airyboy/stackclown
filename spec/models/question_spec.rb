require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should have_many(:tags) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should ensure_length_of(:title).is_at_most(GlobalConstants::QUESTION_TITLE_MAX_LENGTH) }
  it { should ensure_length_of(:body).is_at_most(GlobalConstants::QUESTION_BODY_MAX_LENGTH) }
  
  let!(:question) { FactoryGirl.create(:question) }



  describe 'tags association' do


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

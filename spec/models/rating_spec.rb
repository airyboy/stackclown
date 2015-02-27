require 'rails_helper'

RSpec.describe 'User rating' do


  describe 'voting' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe 'voting for question' do
      before { @question = create(:question, user: user) }

      it 'should add 2 points to user by voting for question' do
        expect{ create(:vote, votable: @question, user: other_user) }.to change{ user.reload.rating }.by(2)
      end

      it 'should substract 2 points to user by voting against question' do
        expect{ create(:vote, points: -1, votable: @question, user: other_user) }.to change{ user.reload.rating }.by(-2)
      end
    end

    describe 'voting for answer' do
      before { @answer = create(:answer, user: user) }

      it 'should add 1 point to user by voting for answer' do
        expect{ create(:vote, votable: @answer, user: other_user) }.to change{user.reload.rating}.by(1)
      end

      it 'should substract 1 point to user by voting against answer' do
        expect{ create(:vote, points: -1, votable: @answer, user: other_user) }.to change{user.reload.rating}.by(-1)
      end
    end
  end

  describe 'answer to question' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:third_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'should add 1 point for second and greater answer' do
      create(:answer, question: question, user: other_user)
      create(:answer, question: question, user: third_user)
      expect(third_user.reload.rating).to eq 1
    end

    it 'should add 2 points for first answer' do
      create(:answer, question: question, user: other_user)
      expect(other_user.reload.rating).to eq 2
    end

    it 'should add 3 points for answering first to his own question' do
      create(:answer, question: question, user: user)
      expect(user.reload.rating).to eq 3
    end

    it 'should add 2 points for answering to his own question but not first' do
      create(:answer, question: question, user: other_user)
      create(:answer, question: question, user: user)
      expect(user.reload.rating).to eq 2
    end

    it 'should add 3 points for marked best answer' do
      answer = create(:answer, question: question, user: other_user)
      expect{ answer.mark_best }.to change{ other_user.reload.rating }.by(3)
    end
  end
end
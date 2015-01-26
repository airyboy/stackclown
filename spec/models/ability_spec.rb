require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest user' do
    let(:user) { nil }

    [Question, Answer, Comment].each do |klass|
      it { should be_able_to :read, klass }
      it { should_not be_able_to :new, klass }
    end

    it { should be_able_to :new, User }
    it { should be_able_to :create, User }
    it { should be_able_to :activate, User }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin user' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'common user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    [Question, Answer, Comment].each do |klass|
      it { should be_able_to :create, klass }
    end

    [:edit, :update, :destroy].product([:question, :answer, :comment_to_question]).collect do |action, resource|
        it { should be_able_to action, create(resource, user: user) }
        it { should_not be_able_to action, create(resource, user: other_user) }
    end

    [:edit, :update, :email, :submit_email].each do |action|
      it { should be_able_to action, user }
    end

    it { should_not be_able_to :create, User }
    it { should_not be_able_to :new, User }
    it { should_not be_able_to :manage, :all }

  end
end
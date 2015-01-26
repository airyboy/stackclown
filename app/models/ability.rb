class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_user : common_user
    else
      guest_user
    end
  end

  def guest_user
    can :read, :all
  end

  def admin_user
    can :manage, :all
  end

  def common_user
    guest_user
    can :edit, User, email: user.email
    can :update, User, email: user.email
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :edit, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment], user: user
  end
end

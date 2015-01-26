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
    can [:edit, :update, :email, :submit_email], User, email: user.email
    can :create, [Question, Answer, Comment]
    can [:edit, :update, :destroy], [Question, Answer, Comment], user: user
  end
end
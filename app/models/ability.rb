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

  private
    def guest_user
      can :read, :all
      can :activate, User
      can :create, User
    end

    def admin_user
      can :manage, :all
    end

    def common_user
      guest_user
      cannot :create, User
      can [:edit, :update, :email, :submit_email], User, email: user.email
      can :create, [Question, Answer, Comment]
      can [:edit, :update, :destroy], [Question, Answer, Comment], user: user
    end
end
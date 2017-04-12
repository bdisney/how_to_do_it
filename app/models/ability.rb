class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :vote_up, :vote_down, to: :vote
    alias_action :update, :destroy, to: :manage_own

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :manage_own, [Question, Answer], user: user
    can :destroy, Comment, user: user

    can :vote, [Question, Answer] do |resource|
      resource.user != user
    end

    can :accept, Answer do |answer|
      answer.question.user == user
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
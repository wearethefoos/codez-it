class Ability

  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      # can [:read], Page, published: true
      can [:read], Post, published: true

      can [:manage], Post,  user_id: user.id
      can [:manage], Authentication,  user_id: user.id
      can [:manage], Account,  user_id: user.id
    end
  end

end

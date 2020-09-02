# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :read, ActiveAdmin::Page, name: 'Dashboard'
      user.permitted_actions.each do |action|
        can :manage, action.class_name.safe_constantize
      end
    end
  end
end

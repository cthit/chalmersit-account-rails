class LdapGroupPolicy < ApplicationPolicy
  attr_reader :user, :record

  def index?
    true
  end

  def show?
    true
  end
  def edit?
    user
  end
  def update?
    edit?
  end
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all_cached
    end
  end
end

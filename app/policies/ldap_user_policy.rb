class LdapUserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def index?
    true
  end

  def show?
    user && (user.admin? || record.uid == user.uid)
  end

  def search?
    true
  end

  def autocomplete?
    search?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    user.admin? || (user.uid == record.uid)
  end

  def remove_avatar?
    update?
  end
  def edit?
    update?
  end

  def destroy?
    false
  end

  def me?
    dashboard?
  end

  def dashboard?
    user && record && record.uid == user.uid
  end

  def admin?
    user && user.admin?
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

class AccountPolicy < ApplicationPolicy
  
  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    user == record.user
  end

  def edit?
    user == record.user
  end

  def destroy? 
    user == record.user
  end
end

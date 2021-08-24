class WalletPolicy < ApplicationPolicy
  def show?
    user == record.user
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

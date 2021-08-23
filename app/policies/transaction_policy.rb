class TransactionPolicy < ApplicationPolicy

	def destroy?
    user.admin?
  end
end
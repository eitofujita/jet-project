class CommentPolicy < ApplicationPolicy
  def create?
    user.present? && record.user == user
  end

  def destroy?
    user.present? && (record.user == user || user.admin?)
  end
end

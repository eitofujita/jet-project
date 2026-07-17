class UserPolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def follow?
    user.present? && user != record
  end
end

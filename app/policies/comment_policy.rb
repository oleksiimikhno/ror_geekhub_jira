class CommentPolicy < ApplicationPolicy
  attr_reader :user, :record

  def create?
    project_member?
  end

  def update?
    comment_author? || user.admin?(@record.task.project)
  end

  def destroy?
    update?
  end

  private

  def project_member?
    @record.commentable.project.memberships.exists?(user_id: user.id)
  end

  def comment_author?
    @record.user_id == user.id
  end
end

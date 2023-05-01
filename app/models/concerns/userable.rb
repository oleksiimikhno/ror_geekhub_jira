module Userable
  extend ActiveSupport::Concern
  include Validatable

  included do
    validate_user_field
    validate_user_field(:last_name)
    validate_email
    validate_password
    validate_github_token
  end

  def restore_projects
    self.projects.only_deleted.each { |project| project.restore }
  end

  def admin?(project)
    id == project.user_id
  end
end
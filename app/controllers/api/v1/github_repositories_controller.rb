class Api::V1::GithubRepositoriesController < ApplicationController
  include Githubable

  before_action :repo_params, only: %i[create update]
  before_action :repo_delete_params, only: %i[delete]
  before_action :set_project, :authorize_user, only: %i[create update delete]

  def create
    repository = GithubRepositoryValidateable.new(repo_params)

    if repository.valid? && @project.present?
      git_create_repo
      @project.update(git_url: @repo&.clone_url, git_repo: @repo&.full_name)

      render_success(data: Api::V1::GithubRepositorySerializer.new(@repo).as_json, status: :ok) if @repo.is_a?(Sawyer::Resource)
    else
      render_error(errors: repository.errors.full_messages)
    end
  end

  def update
    repository = GithubRepositoryValidateable.new(repo_params)

    if repository.valid? && @project.present?
      git_update_repo

      render_success(data: 'Repository update', status: :ok) if @repo.is_a?(Sawyer::Resource)
    else
      render_error(errors: repository.errors.full_messages)
    end
  end

  def delete
    git_find_repo

    unless @repo.nil?
      github_client.delete_repository(params[:validate_text])
      @project.update(git_url: nil, git_repo: nil)

      render_success(data: 'Repository was deleted', status: :ok)
    end
  end

  private

  def authorize_user
    authorize @project
  end

  def repo_params
    params.permit(:project_id, :name, :description, :private, :has_issues, :has_downloads)
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def repo_delete_params
    params.permit(:project_id, :validate_text)
  end
end

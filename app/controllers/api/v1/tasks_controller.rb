class Api::V1::TasksController < ApplicationController
  before_action :task_params, only: %i[create update]
  before_action :set_task, :authorize_user, only: %i[show update destroy]

  def show
    render json: @task, status: :ok, serializer: Api::V1::TaskSerializer
  end

  def create
    task = current_user.tasks.new
    task.update(task_params)

    authorize task

    if task.save
      render json: task, status: :created, serializer: Api::V1::TaskSerializer
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def authorize_user
    authorize @task || Task
  end

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Task not found' }, status: :not_found
  end

  def task_params
    params.permit(
      :project_id, :assignee_id, :desk_id, :column_id, :name, :description, :priority_number, :estimate,
      :label, :priority, :type_of, :status, :start_date, :end_date
    )
  end
end

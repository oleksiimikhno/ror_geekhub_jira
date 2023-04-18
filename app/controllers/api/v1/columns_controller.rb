class Api::V1::ColumnsController < ApplicationController
  before_action :authorize_request
  before_action :column_params, only: %i[create update]
  before_action :set_column, only: %i[show update destroy]
  # TODO create authorize_user policy
  before_action :authorize_user, only: %i[show create update destroy]

  def show
    # add render_success to all methods
    # render_success(data: @column, serializer: ColumnSerializer)
    render json: @column, status: :ok, serializer: Api::V1::ColumnSerializer
  end

  def create
    @column = Column.new(column_params)
    # move logic to model
    @column.ordinal_number = Desk.find_by(id: column_params[:desk_id]).columns.count + 1

    if @column.save
      render json: @column, status: :ok, serializer: Api::V1::ColumnSerializer
    else
      render json: @column.errors, status: :unprocessable_entity
    end
  end

  def update
    if @column.update(column_params)
      render json: @column, status: :ok, serializer: Api::V1::ColumnSerializer
    else
      render json: @column.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @column.destroy
  end

  private

  def authorize_user
    authorize @column || Column
  end

  def set_column
    @column = Column.find(params[:id])
  end

  def column_params
    params.permit(:desk_id, :name, :ordinal_number)
  end
end

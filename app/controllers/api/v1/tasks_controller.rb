class Api::V1::TasksController < Api::V1::BaseController
  before_action :authenticate_with_token!

  def index
    tasks = current_user.tasks
    render json: { tasks: tasks }, status: :ok
  end

  def show
    task = current_user.tasks.find(params[:id])
    render json: task, status: :ok
  end

  def create
    task = current_user.tasks.build(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def update
    task = current_user.tasks.find(params[:id])
    if task.update_attributes(task_params)
      render json: task, status: :ok
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    if task.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :done)
  end
end

class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update toggle_completion ]
  def index
    # Carrega as associações para evitar N+1 queries
    @tasks = Task.includes(:category, :frequency).all

    # Ordena: Pendentes no topo, Concluídas no fim.
    # Entre as pendentes, menor peso total fica mais acima.
    @tasks = @tasks.sort_by do |task|
      [task.completed? ? 1 : 0, task.total_weight]
    end
  end

  # Rota para alternar conclusão
  def toggle_completion
    @task.toggle_completion!

    if @task.completed?
      session[:task_completed] = true
      redirect_to tasks_path, notice: "Tarefa concluída! 🎉"
    else
      session.delete(:task_completed)
      redirect_to tasks_path, notice: "Tarefa reaberta."
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: "Task criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :weight, :category_id, :frequency_id)
  end
end
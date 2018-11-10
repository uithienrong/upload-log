class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end


  def new
    @task = Task.new
  end


  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "The task #{@task.name} has been uploaded."
    else
      render 'new'
    end
  end


  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "The task #{@task.name} has been deleted."
  end

  def detail
    @task = Task.find(params[:id])
    file_path =  "#{Rails.root}/public" + @task.attachment_url
    spreadsheet = open_spreadsheet(file_path)
    @header = spreadsheet.row(1)
    total_rows = spreadsheet.last_row
    @rows = []
    (2..total_rows).each do |row|
      @rows << spreadsheet.row(row)
    end

    render 'detail'
  end

  def open_spreadsheet(file_path)
    case File.extname(file_path)
    when '.xls' then Roo::Excel.new(file_path)
    when '.xlsx' then Roo::Excelx.new(file_path)
    else raise "Unknown type file"
    end
  end



  private
    def task_params
      params.require(:task).permit(:name, :attachment)
    end

end

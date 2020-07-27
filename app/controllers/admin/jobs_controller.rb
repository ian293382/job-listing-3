class Admin::JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def show
    @job = Job.find(params[:id])
  end

  def index
    @jobs = Job.all.paginate(:page => params[:page], :per_page => 7)
  end

  def new
    @job = Job.new

  end

  def create
    @job = Job.new(job_params)


    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])

  end

  def update
    @job = Job.find(params[:id])


    if @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    redirect_to admin_jobs_path
  end

  def publish
    @job = Job.find(params[:id])
    @job.publish!

    redirect_to :back
  end

  def hide
    @job = Job.find(params[:id])
    @job.hide!

    redirect_to :back
  end
private

  def find_job_and_check_permission
    @job = Job.find(params[:id])

    if @job.user != current_user
      redirect_to root_path, alert: "You have no permission"
    end
  end

  def job_params
    params.require(:job).permit(:title, :description,
      :company, :category, :location, :wage_lower_bound,
      :wage_upper_bound, :contact_mail, :is_hidden)
  end
end

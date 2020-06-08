class Admin::ResumesController < ApplicationController
  before_action :authenticate_user!
  brfore_action :require_is_admin

  layout 'admin'

  def index
    @job = Job.find(params[:job_id])
    @resume = @job.resume.order('created at DESC')
  end
end

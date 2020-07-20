class JobsController < ApplicationController
    before_action :authenticate_user!, only: [:favorite]
    before_action :validates_search_key, only: [:search]

    layout 'job'

  def index
        @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 5)
    end

    def show
      @job = Job.find(params[:id])

    end

    def new
      @job = Job.new
    end

    def create
      @job = Job.new(job_params)
      if @job.save
        redirect_to jobs_path
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
        redirect_to jobs_path
      else
        render :edit
      end
    end

    def destroy
      @job = Job.find(params[:id])

      @job.destroy

      redirect_to jobs_path
    end



    def add
       @job = Job.find(params[:id])

       if !current_user.is_member_of?(@job)
         current_user.add_favorite!(@job)
       end

       redirect_to :back
      end

    def remove
       @job = Job.find(params[:id])

       if current_user.is_member_of?(@job)
         current_user.remove_favorite!(@job)
       end

       redirect_to :back
      end

      # search
    def search
    if @query_string.present?
      #顯示jobs公開職位開始搜尋  若加上location(固定資料搜尋時 則替換Job.joins(:location))
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.recent.paginate(:page => params[:page], :per_page => 5 )
    end
  end


  private
    def job_params
      params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound,
         :contact_email, :is_hidden, :contact_email, :company, :category, :location)
    end

   protected

   def validates_search_key
     @query_string = params[:q]
    if params[:q].present?
      @search_criteria =  {
        title_or_company_or_location_orcategory_cont: @query_string
      }
    end
  end

  def search_criteria(query_string)
    { :title_cont => query_string }
  end

end

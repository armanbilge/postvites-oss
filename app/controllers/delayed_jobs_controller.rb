class DelayedJobsController < ApplicationController

  def show
    begin
      @job = DelayedJob.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:info] = 'Completed successfully.'
      flash.keep
      redirect_to Conference.find(params[:conference]) and return
    end
    if @job.failed_at
      flash[:danger] = @job.last_error.split("\n")[0]
      flash.keep
      @job.destroy
      redirect_to Conference.find(params[:conference]) and return
    end
  end

end

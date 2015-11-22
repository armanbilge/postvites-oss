class ConferencesController < ApplicationController

  def index
    if current_user.nil?
      redirect_to root_path
      return
    end
    @conference = Conference.new
  end

  def create
    begin
      @conference = current_user.conferences.create!(conference_params)
      flash[:info] = "Created conference #{@conference.name}."
      redirect_to @conference
    rescue Exception => e
      flash[:danger] = e.message
      redirect_to conferences_path
    end
  end

  def show
    begin
      @conference = Conference.find(params[:id])
    rescue
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      redirect_to conferences_path
    end
  end

  def update
    begin
      @conference = Conference.find(params[:id])
    rescue
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = "You do not have permission to manage conference #{@conference.name}."
      redirect_to conferences_path and return
    end
    begin
      @conference.update!(update_params)
      flash[:info] = 'Limits updated.'
    rescue Exception => e
      flash[:danger] = e.message
    end
    redirect_to @conference
  end


  private

  def conference_params
    params.require(:conference).permit(:name)
  end

  def update_params
    params.require(:conference).permit(:invite_limit, :poster_limit)
  end


end

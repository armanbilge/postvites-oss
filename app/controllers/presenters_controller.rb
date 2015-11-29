class PresentersController < ApplicationController

  def show
    @presenter = Presenter.find_by_secret(params[:secret]) or not_found
  end

  def update
    @presenter = Presenter.find_by_secret(params[:secret]) or not_found
    begin
      @presenter.update!(update_params)
      flash[:info] = 'Your invitations have been saved.'
    rescue Exception => e
      flash[:danger] = e.message
    end
    redirect_to @presenter
  end

  private

  def update_params
    params.require(:presenter).permit(attendee_ids: [])
  end

end

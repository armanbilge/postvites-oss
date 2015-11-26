class PresentersController < ApplicationController

  def show
    @presenter = Presenter.find_by_secret(params[:secret])
  end

  def edit
    @presenter = Presenter.find_by_secret(params[:secret])
  end

end

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

  def page
    require 'set'
    @presenter = Presenter.find_by_secret(page_params[:secret]) or not_found
    invited = Set.new(@presenter.attendees.select(:id))
    if page_params[:selected]
      attendees = @presenter.attendees
    else
      attendees = @presenter.available_attendees
    end
    # See http://jakzaprogramowac.pl/pytanie/23746,how-to-write-set-operation-queries-in-activerecord-without-writing-intersect-union-or-except-in-sql
    query = attendees
    for k in page_params.fetch(:keyword_ids, [])
      query = query.where('exists (select 1 from attendee_keywords ak where ak.attendee_id = attendees.id and keyword_id = ?)', k)
    end
    data = query.order(:last, :first).page(page_params[:page].to_i).per(page_params[:per].to_i).map do |a|
      {
        first: a.first,
        last: a.last,
        affiliation: a.affiliation,
        invited: invited.include?(a.id)
      }
    end
    render json: data
  end

  private

  def update_params
    params.require(:presenter).permit(attendee_ids: [])
  end

  def page_params
    params.permit(:secret, :selected, :page, :per, keyword_ids: [])
  end

end

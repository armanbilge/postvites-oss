class PresentersController < ApplicationController

  def show
    @presenter = Presenter.find_by_secret(params[:secret]) or not_found
  end

  def mobile
    @presenter = Presenter.find_by_secret(params[:secret]) or not_found
    render layout: false
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
    @presenter = Presenter.find_by_secret(page_params[:secret]) or not_found
    invited = @presenter.attendees.pluck(:id).to_set
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
    length = query.count
    rows = query.order(:last, :first).offset(page_params[:offset].to_i).limit(page_params[:limit].to_i).map do |a|
      {
        id: a.id,
        vital: a.vital,
        invited: invited.include?(a.id)
      }
    end
    render json: {length: length, rows: rows}
  end

  private

  def update_params
    params.require(:presenter).permit(attendee_ids: [])
  end

  def page_params
    params.permit(:secret, :selected, :offset, :limit, keyword_ids: [])
  end

end

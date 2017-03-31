class InvitationsController < ApplicationController

  def show
    @presenter = Presenter.find_by_secret(params[:presenter_secret])
    @invitation = Invitation.find_or_initialize_by(attendee_id: params[:attendee_id], presenter: @presenter)
    render layout: false
  end

  def update
    begin
      @presenter = Presenter.find_by_secret(params[:presenter_secret])
      @invitation = Invitation.find_or_create_by(attendee_id: params[:attendee_id], presenter: @presenter)
      @invitation.update!(update_params)
      flash[:info] = 'Changes saved.'
      redirect_to invitation_path(@invitation)
    rescue Exception => e
      flash[:danger] = e.message
      redirect_to invitation_path(@invitation)
    end
  end

  def invitation_path(invitation)
    "/invitations/#{invitation.presenter.secret}/#{invitation.attendee_id}"
  end

  private

  def update_params
    params.require(:invitation).permit(:include_email, :message)
  end

end

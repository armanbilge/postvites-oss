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
      @invitation.update!(update_params.except(:mobile))
      flash[:info] = 'Changes saved.'
      if update_params[:mobile]
        render status: 200, json: {}
      else
        redirect_to invitation_path(@invitation)
      end
    rescue Exception => e
      flash[:danger] = e.message
      if update_params[:mobile]
        render status: 500, json: {}
      else
        redirect_to invitation_path(@invitation)
      end
    end
  end

  def json
    presenter = Presenter.find_by_secret(params[:presenter_secret])
    invitation = Invitation.find_or_initialize_by(attendee_id: params[:attendee_id], presenter: presenter)
    render json: {
      attendee: invitation.attendee.vital,
      message: invitation.message.to_s,
      include_email: invitation.include_email?
    }
  end

  def destroy
    presenter = Presenter.find_by_secret(params[:presenter_secret])
    invitation = Invitation.find_or_initialize_by(attendee_id: params[:attendee_id], presenter: presenter)
    invitation.destroy()
    render status: 200, json: {}
  end

  def invitation_path(invitation)
    "/invitations/#{invitation.presenter.secret}/#{invitation.attendee_id}"
  end

  private

  def update_params
    params.require(:invitation).permit(:include_email, :message, :mobile)
  end

end

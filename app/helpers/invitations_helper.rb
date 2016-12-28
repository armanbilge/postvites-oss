module InvitationsHelper

  def invitations_path
    "/invitations"
  end

  def invitation_path(invitation)
    "/invitations/#{invitation.presenter_id}/#{invitation.attendee_id}"
  end

end

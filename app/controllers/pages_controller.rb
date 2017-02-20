class PagesController < ApplicationController

  def contact
    session[:referer] = request.referer
  end

  def send_message
    params = send_message_params
    ActionMailer::Base.mail(to: Rails.configuration.x.admin_email, subject: 'Message from postvites user', body: "#{params[:name]} <#{params[:email]}> wrote the following message:\n\n" + params[:message]).deliver_now
    flash[:info] = 'Thanks, your message has been received.'
    redirect_to session[:referer].nil? ? root_path : session.delete(:referer)
  end

  def send_message_params
    params.require(:contact).permit(:name, :email, :message)
  end

end

class PagesController < ApplicationController

  def contact
    session[:referer] = request.referer
  end

  def send_message
    params = send_message_params
    begin
      ActionMailer::Base.mail(to: Rails.configuration.x.admin_email, from: "#{params[:name]} <#{params[:email]}>", subject: 'Message from postvites user', body: params[:message]).deliver_now
      flash[:info] = 'Thanks, your message has been received.'
    rescue Exception => e
      flash[:danger] = e.message
      redirect_to controller: 'pages', action: 'contact' and return
    end
    redirect_to session[:referer].nil? ? root_path : session.delete(:referer)
  end

  def send_message_params
    params.require(:contact).permit(:name, :email, :message)
  end

end

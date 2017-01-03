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
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    begin
      @conference.update!(update_params)
      flash[:info] = 'Changes saved.'
    rescue Exception => e
      flash[:danger] = e.message
    end
    redirect_to @conference
  end

  def upload
    begin
      @conference = Conference.find(params[:id])
    rescue
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    begin
      params = upload_params

      @table = params[:table]

      csv = params[:csv]
      if csv.blank?
        flash[:danger] = 'No file selected.'
        redirect_to @conference and return
      end

      require 'csv'
      @path = csv.path
      @headers = CSV.open(@path) { |csv| csv.first }

      flash.now[:info] = 'Uploaded CSV file.'

    rescue Exception => e
      flash[:danger] = e.message
      redirect_to @conference
    end
  end

  def import_attendees
    begin
      @conference = Conference.find(params[:id])
    rescue
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    begin
      params = import_attendees_params
      job = File.open(params[:path], 'rb') do |f|
        @conference.import_attendees(f.read, params.except(:path))
      end
      redirect_to "/jobs/#{job.id}/#{@conference.id}" and return
    rescue Exception => e
      flash[:danger] = e.message
    end
    redirect_to @conference
  end

  def import_presenters
    begin
      @conference = Conference.find(params[:id])
    rescue
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    begin
      params = import_presenters_params
      job = File.open(params[:path], 'rb') do |f|
        @conference.import_presenters(f.read, params.except(:path))
      end
      redirect_to "/jobs/#{job.id}/#{@conference.id}" and return
    rescue Exception => e
      flash[:danger] = e.message
    end
    redirect_to @conference
  end

  def email_presenters
    begin
      @conference = Conference.find(params[:id])
    rescue
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.presenters_emailed?
      flash[:danger] = 'Presenters have already been emailed.'
      redirect_to conferences_path and return
    end
    begin
      params = email_presenters_params
      deadline = Date.new(params['deadline(1i)'].to_i, params['deadline(2i)'].to_i, params['deadline(3i)'].to_i)
      if deadline < Date.today - 1
        flash[:danger] = 'Presenter deadline must be in the future.'
        redirect_to @conference and return
      end
      @conference.update!(deadline: deadline, presenters_emailed: true)
      @conference.presenters.each do |p|
        Notifier.delay.request_selections(p, params[:subject], params[:message], deadline)
      end
      flash[:info] = 'Emailed presenters.'
    rescue Exception => e
      @conference.update!(presenters_emailed: false)
      flash[:danger] = e.message
    end
    redirect_to @conference
  end

  def email_attendees
    begin
      @conference = Conference.find(params[:id])
    rescue
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.user != current_user
      flash[:danger] = 'Conference does not exist.'
      redirect_to conferences_path and return
    end
    if @conference.attendees_emailed?
      flash[:danger] = 'Invitations have already been sent'
      redirect_to conferences_path and return
    end
    begin
      redirect_to @conference
      @conference.update!(attendees_emailed: true)
      params = email_attendees_params
      @conference.attendees.each do |a|
        Notifier.delay.invite(a, params[:subject], params[:message]) unless a.presenters.count == 0
        if params[:remind]
          presenters.distinct.pluck(:session_day).each do |day|
            if a.presenters.where(session_day: day).count > 0
              Notifier.delay(run_at: day.in_time_zone(get_time_zone) + 5.hours).remind(a, 'Reminder: ' + subject, day)
            end
          end
        end
      end
      flash[:info] = 'Emailed invitations to attendees.'
    rescue Exception => e
      @conference.update!(attendees_emailed: false)
      flash[:danger] = e.message
    end
  end

  private

  def conference_params
    params.require(:conference).permit(:name)
  end

  def update_params
    params.require(:conference).permit(:invite_limit, :poster_limit, :email, :logo_url, :time_zone)
  end

  def upload_params
    params.require(:conference).permit(:csv, :table)
  end

  def import_attendees_params
    params.require(:conference).permit(:path, :last, :first, :email, :affiliation, keywords: [])
  end

  def import_presenters_params
    params.require(:conference).permit(:path, :last, :first, :email, :affiliation, :title, :session, :location, :session_day, :session_start, :session_end, :number, :abstract)
  end

  def email_presenters_params
    params.require(:email).permit(:subject, :message, 'deadline(1i)', 'deadline(2i)', 'deadline(3i)', :remind)
  end

  def email_attendees_params
    params.require(:email).permit(:subject, :message)
  end

end

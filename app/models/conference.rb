class Conference < ActiveRecord::Base

  belongs_to :user
  has_many :attendees
  has_many :presenters
  has_many :keywords

  validates :name, presence: true
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone::MAPPING.keys }
  validates :hashtag, allow_blank: true, format: { with: /\A#/ }
  validates :email, allow_blank: true, format: { with: /@/ }
  validates :invite_limit, numericality: { greater_than_or_equal_to: 1 }
  validates :poster_limit, numericality: { greater_than_or_equal_to: 1 }

  def step
    [(self.attendees.count > 0 && self.presenters.count > 0), self.presenters_emailed, self.attendees_emailed].count(true)
  end

  def available_attendees
    attendees.joins('left join invitations on attendees.id = invitations.attendee_id').group('attendees.id').having("count(attendee_id) < #{poster_limit}")
  end

  def get_time_zone
    ActiveSupport::TimeZone.new(time_zone)
  end

  require 'csv'
  require 'tempfile'
  require 'charlock_holmes'

  def import_attendees(data, mapping)
    path = Tempfile.open('attendees', Rails.root.join('tmp')) do |f|
      f.binmode
      f.write(data)
      f
    end
    Conference.transaction do
      self.attendees.delete_all
      self.keywords.delete_all
      CSV.foreach(path, headers: true, encoding: CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]) do |row|
        params = mapping.map { |k, v|
          if v.is_a?(Array)
            [k, v.map { |x| row[x] }.join(';')]
          else
            [k, row[v]]
          end
        }.to_h
        if params['keywords']
          params['keywords'] = params['keywords'].split(';').map { |k| self.keywords.find_or_create_by!(name: k.downcase) }
        else
          params['keywords'] = []
        end
        self.attendees.create!(params)
      end
    end
  end
  handle_asynchronously :import_attendees

  def import_presenters(data, mapping)
    path = Tempfile.open('attendees', Rails.root.join('tmp')) do |f|
      f.binmode
      f.write(data)
      f
    end
    require 'chronic'
    require 'securerandom'
    Conference.transaction do
      self.presenters.delete_all
      Chronic.time_class = get_time_zone
      CSV.foreach(path, headers: true, encoding: CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]) do |row|
        params = mapping.map { |k, v| [k, row[v]] }.to_h
        secret = nil
        loop do
          secret = SecureRandom.hex
          break unless Presenter.exists?(secret: secret)
        end
        params[:secret] = secret
        params['session_day'] = Chronic.parse(params['session_day'])
        self.presenters.create!(params)
      end
    end
  end
  handle_asynchronously :import_presenters

end

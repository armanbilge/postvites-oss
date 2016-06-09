class Conference < ActiveRecord::Base

  belongs_to :user
  has_many :attendees
  has_many :presenters
  has_many :keywords

  validates :name, presence: true
  validates :email, :allow_blank => true, format: { with: /@/, on: :create }
  validates :invite_limit, numericality: { greater_than_or_equal_to: 1 }
  validates :poster_limit, numericality: { greater_than_or_equal_to: 1 }

  def step
    [(self.attendees.count > 0 && self.presenters.count > 0), self.presenters_emailed, self.attendees_emailed].count(true)
  end

  def available_attendees
    attendees.joins('left join invitations on attendees.id = invitations.attendee_id').group('attendees.id').having("count(attendee_id) < #{poster_limit}")
  end

  require 'csv'
  require 'charlock_holmes'

  def import_attendees(path, mapping)
    Conference.transaction do
      self.attendees.delete_all
      self.keywords.delete_all
      CSV.foreach(path, headers: true, encoding: CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]) do |row|
        params = mapping.each_pair.map { |k, v| [k, row[v]] }.to_h
        params['keywords'] = params['keywords'].split(',').map { |k| self.keywords.find_or_create_by!(name: k.downcase) }
        self.attendees.create!(params)
      end
    end
  end

  def import_presenters(path, mapping)
    require 'securerandom'
    Conference.transaction do
      self.presenters.delete_all
      CSV.foreach(path, headers: true, encoding: CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]) do |row|
        attributes = mapping.each_pair.map { |k, v| [k, row[v]] }.to_h
        secret = nil
        loop do
          secret = SecureRandom.hex
          break unless Presenter.exists?(secret: secret)
        end
        attributes[:secret] = secret
        self.presenters.create!(attributes)
      end
    end
  end

end

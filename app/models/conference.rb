class Conference < ActiveRecord::Base

  validates :name, presence: true
  validates :invite_limit, numericality: { greater_than_or_equal_to: 1 }
  validates :poster_limit, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :user
  has_many :attendees
  has_many :presenters

  def step
    [(self.attendees.count > 0 && self.presenters.count > 0), self.presenters_emailed, self.attendees_emailed].count(true)
  end

  require 'csv'

  def import_attendees(path, mapping)
    self.attendees.delete_all
    begin
      CSV.foreach(path, headers: true) do |row|
        self.attendees.create!(mapping.each_pair.map { |k, v| [k, row[v]] }.to_hash)
      end
    rescue Exception => e
      self.attendees.delete_all
      raise e
    end
  end

  def import_presenters(path, mapping)
    require 'securerandom'
    self.presenters.delete_all
    begin
      CSV.foreach(path, headers: true) do |row|
        attributes = mapping.each_pair.map { |k, v| [k, row[v]] }.to_hash
        loop do
          secret = SecureRandom.hex
          break unless Presenter.exists?(secret: secret)
        end
        attributes[:secret] = secret
        self.presenters.create!(attributes)
      end
    rescue Exception => e
      self.presenters.delete_all
      raise e
    end
  end

end

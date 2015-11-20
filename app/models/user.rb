class User < ActiveRecord::Base

  validates :provider, :uid, :presence => true

  has_many :conferences

  class << self
    def from_omniauth(auth_hash)
      User.create_with(name: auth_hash[:info][:name]).find_or_create_by!(uid: auth_hash[:uid], provider: auth_hash[:provider])
    end
  end

end

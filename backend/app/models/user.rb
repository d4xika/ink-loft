class User < ApplicationRecord
  has_secure_password
  has_many :auth_keys
  has_many :books
  has_many :quotes

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_fill: [ 100, 100 ]
  end

  enum :language, [ :en, :de, :noe, :sue ]

  def generate_auth_key
    auth_key = "ink-loft-#{SecureRandom.hex(16)}"
    return AuthKey.create(user: self, key: auth_key)
  end
end

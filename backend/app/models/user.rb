class User < ApplicationRecord
  has_secure_password
  has_many :auth_keys
  has_many :reads
  has_many :quotes

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_fill: [ 200, 200 ]
    attachable.variant :medium, resize_to_fill: [ 500, 500 ]
    attachable.variant :large, resize_to_fill: [ 1000, 1000 ]
  end

  enum :language, [ :en, :de, :noe, :sue ]

  def generate_auth_key
    auth_key = "ink-loft-#{SecureRandom.hex(16)}"
    return AuthKey.create(user: self, key: auth_key)
  end
end

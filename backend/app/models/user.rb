class User < ApplicationRecord
  has_secure_password
  has_many :auth_keys
  has_many :books
  has_many :quotes

  has_one_attached :avatar do |attachable|
    attachable.variant :small,
                       resize_to_fill: [1000, 1000],
                       modulate: "80,55,100",
                       colorize: "10,5,0",
                       level: "5%,90%",
                       contrast: true,
                       blur: "0x1.5",
                       paint: 3,
                       colorspace: "Gray"
    attachable.variant :large,
                       resize_to_fill: [1000, 1000],
                       modulate: "80,55,100",
                       colorize: "10,5,0",
                       level: "5%,90%",
                       contrast: true,
                       blur: "0x1.5",
                       paint: 6,
                       colorspace: "Gray"
  end

  enum :language, [ :en, :de, :noe, :sue ]

  def generate_auth_key
    auth_key = "ink-loft-#{SecureRandom.hex(16)}"
    return AuthKey.create(user: self, key: auth_key)
  end
end

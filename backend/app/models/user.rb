class User < ApplicationRecord
  has_secure_password
  has_many :auth_keys
  has_many :reads
  has_many :quotes
  has_many :friendships_as_user_one,
           class_name: "Friendship",
           foreign_key: :user_one_id,
           dependent: :destroy
  has_many :friendships_as_user_two,
           class_name: "Friendship",
           foreign_key: :user_two_id,
           dependent: :destroy
  has_many :sent_friend_requests,
           class_name: "Friendship",
           foreign_key: :requested_by_id,
           dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_fill: [ 200, 200 ]
    attachable.variant :medium, resize_to_fill: [ 500, 500 ]
    attachable.variant :large, resize_to_fill: [ 1000, 1000 ]
  end

  enum :language, [ :en, :de, :noe, :sue ]

  validates :updates_seen_count,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true

  def generate_auth_key
    auth_key = "ink-loft-#{SecureRandom.hex(16)}"
    return AuthKey.create(user: self, key: auth_key)
  end
end

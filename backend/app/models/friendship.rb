class Friendship < ApplicationRecord
  belongs_to :user_one, class_name: "User"
  belongs_to :user_two, class_name: "User"
  belongs_to :requested_by, class_name: "User"

  enum :status, { pending: 0, accepted: 1 }

  validates :user_two_id, uniqueness: { scope: :user_one_id }
  validate :users_are_different
  validate :requester_belongs_to_friendship

  scope :involving, ->(user) { where(user_one: user).or(where(user_two: user)) }

  def self.between(first_user, second_user)
    first_id, second_id = [ first_user.id, second_user.id ].sort
    find_by(user_one_id: first_id, user_two_id: second_id)
  end

  def self.request(first_user, second_user)
    first_id, second_id = [ first_user.id, second_user.id ].sort
    create(user_one_id: first_id, user_two_id: second_id, requested_by: first_user)
  end

  def other_user(user)
    user_one_id == user.id ? user_two : user_one
  end

  private

  def users_are_different
    errors.add(:user_two, "must be different from user one") if user_one_id == user_two_id
  end

  def requester_belongs_to_friendship
    return if [ user_one_id, user_two_id ].include?(requested_by_id)

    errors.add(:requested_by, "must belong to the friendship")
  end
end

class Book < ApplicationRecord
  belongs_to :user

  enum :reading_status, { want_to_read: 0, currently_reading: 1, have_read: 2 }

  def as_json(options = {})
    json = super(options)
    json[:reading_status] = reading_status_before_type_cast
    return json
  end
end

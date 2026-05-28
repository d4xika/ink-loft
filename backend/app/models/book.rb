class Book < ApplicationRecord
  belongs_to :user

  has_many :quotes
  has_one_attached :cover

  enum :reading_status, { want_to_read: 0, currently_reading: 1, have_read: 2, dropped: 3 }

  def as_json(options = {})
    json = super(options)
    json[:reading_status] = reading_status

    if cover.attached?
      base_url = Rails.env.production? ? "https://inkloft-backend.p4s3r0.it" : "http://127.0.0.1:3000"
      json[:cover_url] = Rails.application.routes.url_helpers.rails_blob_url(cover, host: base_url)
    end

    return json
  end
end

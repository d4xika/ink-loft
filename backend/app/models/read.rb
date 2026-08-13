class Read < ApplicationRecord
  belongs_to :user

  has_many :quotes
  has_one_attached :cover do |attachable|
    attachable.variant :small, resize_to_fill: [ 200, 280 ]
    attachable.variant :medium, resize_to_fill: [ 500, 700 ]
  end

  enum :reading_status, { want_to_read: 0, currently_reading: 1, have_read: 2, dropped: 3 }

  def as_json(options = {})
    json = super(options)
    json[:reading_status] = reading_status

    if cover.attached?
      base_url = Rails.env.production? ? "https://ink-loft.d4xika.com" : "http://127.0.0.1:3000"
      json[:cover_url] = Rails.application.routes.url_helpers.rails_blob_url(cover, host: base_url)
      json[:cover_small_url] = Rails.application.routes.url_helpers.rails_representation_url(cover.variant(:small), host: base_url)
      json[:cover_medium_url] = Rails.application.routes.url_helpers.rails_representation_url(cover.variant(:medium), host: base_url)
    end

    return json
  end
end

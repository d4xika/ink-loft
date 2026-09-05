class Activity < ApplicationRecord
  belongs_to :user

  enum :action, [ :started_read, :finished_read, :dropped_read ]
end


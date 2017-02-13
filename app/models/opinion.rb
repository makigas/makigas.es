class Opinion < ApplicationRecord
  has_attached_file :photo, styles: {
    default: "640x640>",
    small: "240x240"
  }

  validates :from, presence: true, length: { maximum: 50 }
  validates :message, presence: true, length: { maximum: 200 }
  validates :photo, presence: true
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\z/ }
end

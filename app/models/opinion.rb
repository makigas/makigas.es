class Opinion < ApplicationRecord
  has_attached_file :photo, styles: {
    default: "320x320>",
    small: "160x160>"
  }

  validates :from, presence: true, length: { maximum: 50 }
  validates :message, presence: true, length: { maximum: 200 }
  validates :photo, presence: true
  validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\z/ }

  def to_s
    from
  end
end

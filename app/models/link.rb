# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :integer
#  url         :string
#  description :string
#
# Indexes
#
#  index_links_on_video_id  (video_id)
#

class Link < ApplicationRecord
  # Relations
  belongs_to :video, required: true

  # Validations
  validates :url, presence: true, length: { maximum: 1024 }
  validates :description, presence: true, length: { maximum: 256 }
  validates :video, presence: true
end

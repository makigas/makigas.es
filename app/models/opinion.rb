# frozen_string_literal: true

# == Schema Information
#
# Table name: opinions
#
#  id                 :integer          not null, primary key
#  from               :string           not null
#  message            :string           not null
#  photo_content_type :string           not null
#  photo_file_name    :string           not null
#  photo_file_size    :bigint           not null
#  photo_updated_at   :datetime         not null
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Opinion < ApplicationRecord
  has_attached_file :photo, styles: {
    default: '320x320>',
    small: '160x160>'
  }

  validates :from, presence: true, length: { maximum: 50 }
  validates :message, presence: true, length: { maximum: 200 }
  validates :photo, presence: true
  validates_attachment :photo, content_type: { content_type: %r{\Aimage/.*\z} }

  def to_s
    from
  end
end

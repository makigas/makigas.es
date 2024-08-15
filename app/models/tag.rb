# == Schema Information
#
# Table name: tags
#
#  id                :bigint           not null, primary key
#  description       :string           not null
#  icon_content_type :string
#  icon_file_name    :string
#  icon_file_size    :bigint
#  icon_updated_at   :datetime
#  slug              :string           not null
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_tags_on_slug  (slug) UNIQUE
#
class Tag < ApplicationRecord
  has_attached_file :icon

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :icon, presence: true
  validates_attachment :icon, content_type: { content_type: %r{\Aimage/.*\z} }

  def to_param
    slug
  end
end

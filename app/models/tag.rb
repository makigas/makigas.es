# frozen_string_literal: true

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
#  synonyms          :string           default([]), not null, is an Array
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_tags_on_slug  (slug) UNIQUE
#
class Tag < ApplicationRecord
  ICON_VARIANTS = {
    default: [64, 64],
    hidef: [128, 128]
  }.freeze

  has_one_attached :icon

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :icon, image_attachment: true

  def to_param
    slug
  end

  def icon_variant(style)
    icon.variant(resize_to_limit: ICON_VARIANTS.fetch(style), format: icon_format)
  end

  def self.synonym(syn)
    where('synonyms @> ARRAY[?]::varchar[]', syn).first
  end

  after_save do
    Tag.deploy_synonyms
  end

  def self.synonyms_catalog
    Tag.pluck(:slug, :synonyms).to_h.tap do |index|
      # Make it bidirectional
      index.deep_dup.each do |slug, synonyms|
        synonyms.each do |syn|
          index[syn] = [] if index[syn].blank?
          index[syn] << slug
        end
      end
    end
  end

  def self.deploy_synonyms
    Video.index.update_synonyms(synonyms_catalog)
  end

  private

  def icon_format
    { 'image/jpeg' => 'jpg', 'image/png' => 'png', 'image/gif' => 'gif', 'image/webp' => 'webp',
      'image/tiff' => 'tiff', 'image/bmp' => 'bmp' }.fetch(icon.blob.content_type) do
      icon.blob.filename.extension_without_delimiter.presence&.downcase || 'png'
    end
  end
end

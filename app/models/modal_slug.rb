# frozen_string_literal: true

class ModalSlug
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :slug, :string
  attribute :reset, :boolean, default: false
  validates :id, :slug, presence: true

  def update_slug!
    next_slug = if reset
                  nil
                else
                  slug
                end
    video.update(slug: next_slug)
  end

  def video
    @video ||= Video.find(id)
  end
end

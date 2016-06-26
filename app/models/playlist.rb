class Playlist < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 100 }

  rails_admin do
    list do
      field :title
      field :description
    end

    edit do
      field :title
      field :description
      field :youtube_id do
        label 'Playlist ID'
      end
    end

    configure :youtube_id do
      label 'Playlist ID'
    end
  end
end

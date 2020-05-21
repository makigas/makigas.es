# frozen_string_literal: true

class Link < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :url, presence: true

  belongs_to :video
end

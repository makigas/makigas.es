# frozen_string_literal: true

class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true, touch: true
  validates :language, presence: true
end

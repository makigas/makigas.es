# frozen_string_literal: true

module Search
  # This is the form object to manage and validate search filters before
  # passing them to the search engine. The search engine will accept one
  # instance of Search::Filters.
  class Filters
    class << self
      def clean(**)
        new(**).tap(&:clean!)
      end
    end

    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations

    ACCEPTABLE_CONTENT_TYPES = %i[videos playlists].freeze
    ACCEPTABLE_SORT_CRITERIAS = %i[relevance recent popular trending].freeze

    attribute :query, :string
    attribute :page, :integer, default: 1
    attribute :per_page, :integer, default: 20
    attribute :tag, :string, default: nil
    attribute :content_type, :symbol, default: nil
    attribute :sort, :symbol, default: nil
    attribute :exclude_obsolete, :boolean, default: false
    attribute :articles, :boolean, default: false

    validates :page, numericality: { only_integer: true, greater_than: 0 }
    validates :per_page, numericality: { only_integer: true, greater_than: 0 }
    validates :content_type, inclusion: { in: ACCEPTABLE_CONTENT_TYPES }, allow_blank: true
    validates :sort, inclusion: { in: ACCEPTABLE_SORT_CRITERIAS }, allow_blank: true

    def clean!
      validate
      defaults = self.class.new
      errors.to_hash.each_key do |k|
        assign_attributes(k => defaults.send(k))
      end
    end

    def derive(**changeset)
      self.class.new(attributes).tap { |new| new.assign_attributes(changeset) }
    end
  end
end

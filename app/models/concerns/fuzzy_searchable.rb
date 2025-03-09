# frozeon_string_literal: true

module FuzzySearchable
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model
  end

  BASE_SIMILARITY = 0.5

  class_methods do
    def fuzzy_search_by(attributes, value, threshold: nil, limit: 10)
      return none if attributes.blank? || value.blank?

      attributes = Array(attributes).map(&:to_s)

      pg_search_scope :search_dynamic,
                      against: attributes.map(&:to_sym),
                      using: {
                        trigram: { threshold: threshold || BASE_SIMILARITY }
                        # dmetaphone: {} - To debug, not working in tests
                      }

      search_dynamic(value).limit(limit).extending(nil)
    end
  end
end

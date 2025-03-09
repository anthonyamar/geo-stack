# frozen_string_literal: true

require "test_helper"

class FuzzySearchableTest < ActiveSupport::TestCase
  setup do
    skip "Skipping fuzzy_searchable test - no model with fuzzy_searchable concern."
    # Replace with any model that has the fuzzy_searchable concern
    @records = [
      create(:record_with_fuzzy_searchable, name: "moyadez"),
      create(:record_with_fuzzy_searchable, name: "moyades"),
      create(:record_with_fuzzy_searchable, name: "moiades"),
      create(:record_with_fuzzy_searchable, name: "moiadez")
    ]
  end

  test "basic search with 0.5 similarity" do
    assert_same_elements RecordWithFuzzySearchable.fuzzy_search_by(:name, "Moyades"), @records[0..1]
  end

  test "multiple attributes" do
    expected = [
      create(:other_record, name: "TekMarseile", email: "tekmarseille@example.com"),
      create(:other_record, name: "TecMarseille", email: "tecmarseile@example.com")
    ]
    assert_equal OtherRecord.fuzzy_search_by(%i[name email], "TekMarseille").first, expected.first
  end

  test "allow optional similarity threshold and limit" do
    assert_equal RecordWithFuzzySearchable.fuzzy_search_by(:name, "Moyades", threshold: 0.9).first, @records[1]

    # Default order is by similarity
    assert_equal RecordWithFuzzySearchable.fuzzy_search_by(:name, "Moyades", limit: 1).first, @records[1]

    assert_same_elements RecordWithFuzzySearchable.fuzzy_search_by(
      :name, "Moyades",
      threshold: 0.1,
      limit: 3
    ).to_a, @records[0..2]
  end
end

# frozen_string_literal: true

# Pagy initializer (43.x)
# See https://ddnexus.github.io/pagy/resources/initializer/

# Required for custom nav components that call pagy.series directly (e.g. Ui::PaginationComponent)
require "pagy/toolbox/helpers/support/series"

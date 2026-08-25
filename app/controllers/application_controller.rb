# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include LocaleConcern
  include Pagy::Method

  helper LocaleHelper
end

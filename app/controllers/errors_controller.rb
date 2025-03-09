# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render :not_found, status: :not_found
  end

  def unacceptable
    render :unacceptable, status: :unprocessable_entity
  end

  def internal_server_error
    render :internal_server_error, status: :internal_server_error
  end
end

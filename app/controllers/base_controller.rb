# frozen_string_literal: true

class BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  before_action :authenticate_user!

  private

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def unprocessable_entity(record)
    render json: { errors: record.errors }, status: :unprocessable_entity
  end
end

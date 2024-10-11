# frozen_string_literal: true

class FeedController < BaseController
  def index
    @feed = FeedService.new(current_user).call
    render json: serialize_feed(@feed)
  end

  private

  def serialize_feed(feed)
    FeedSerializer.new.serialize_to_json(feed)
  end
end

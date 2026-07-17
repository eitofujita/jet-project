class FeedsController < ApplicationController
  before_action :require_authentication

  def show
    @posts = FeedQuery.new(user: current_user).call
  end
end

class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed.newest,
                              items: Settings.post.items_5
  end

  def help; end

  def contact; end
end

class StaticPagesController < ApplicationController
  def privacy
    self.class.layout "static_pages/static_pages"
  end

  def error_404
    render status: 404, layout: false
  end
end
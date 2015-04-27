class StaticPagesController < ApplicationController
  def privacy
    self.class.layout "static_pages/static_pages"
  end
end
module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_tile = t("base_tile")
    page_title.empty? ? base_tile : "#{page_title} | #{base_tile}"
  end
end

module TopTags
  extend ActiveSupport::Concern

  included do
    before_action :top_tags, only: [:index]
  end

  def top_tags
    @tags = Tag.all
  end
end
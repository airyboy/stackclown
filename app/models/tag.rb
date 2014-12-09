class Tag < ActiveRecord::Base
  before_save :downcase_tag_name
  VALID_TAG_NAME_REGEX = /\A[^_\s]*\z/
  validates :tag_name, presence: true, format: { with: VALID_TAG_NAME_REGEX },
            uniqueness: { case_sensitive: false }, length: { maximum: GlobalConstants::TAG_NAME_MAX_LENGTH }

  has_many :tag_relationships
  has_many :questions, through: :tag_relationships

  def downcase_tag_name
    tag_name.downcase!
  end
end
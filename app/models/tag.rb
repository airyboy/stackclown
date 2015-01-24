# create_table :tags, force: true do |t|
#   t.string   :tag_name
#   t.datetime :created_at
#   t.datetime :updated_at
# end
#
# add_index :tags, [:tag_name], name: :index_tags_on_tag_name, using: :btree

class Tag < ActiveRecord::Base
  has_many :tag_relationships
  has_many :questions, through: :tag_relationships

  VALID_TAG_NAME_REGEX = /\A[^_\s]*\z/
  validates :tag_name, presence: true, format: { with: VALID_TAG_NAME_REGEX },
            uniqueness: { case_sensitive: false }, length: { maximum: GlobalConstants::TAG_NAME_MAX_LENGTH }

  before_save :downcase_tag_name

  private
    def downcase_tag_name
      tag_name.downcase!
    end
end

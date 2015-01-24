# create_table :attachments, force: true do |t|
#   t.string   :file
#   t.datetime :created_at
#   t.datetime :updated_at
#   t.integer  :attachable_id
#   t.string   :attachable_type
# end
#
# add_index :attachments, [:attachable_id, :attachable_type], name: :index_attachments_on_attachable_id_and_attachable_type, using: :btree

class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :attachable, polymorphic: true
end

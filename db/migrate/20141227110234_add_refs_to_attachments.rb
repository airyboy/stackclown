class AddRefsToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :attachable, polymorphic: true
  end
end

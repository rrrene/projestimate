class AddAttachmentsIcons < ActiveRecord::Migration
  def change
    add_attachment :peicons, :icon
  end
end

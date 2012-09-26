class ModifyAttrTypeIntoAttributes < ActiveRecord::Migration
  def up
    change_table :attributes do |t|
      t.change :attr_type, :string
    end
  end

  def down
    change_table :attributes do |t|
      t.change :attr_type, :integer
    end
  end
end

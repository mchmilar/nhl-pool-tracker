class DropAdmin < ActiveRecord::Migration
  def change
    drop_table :Admins
  end
end

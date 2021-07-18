class AddColToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :is_fiction, :Boolean, null:false
  end
end

class AddDiscardedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :discarded_at, :datetime
  end
end

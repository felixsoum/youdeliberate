class AddNumFlagsToNComments < ActiveRecord::Migration
  def change
    add_column :n_comments, :num_flags, :int,  default: 0
  end
end

class ReindexAllActivitySequences < ActiveRecord::Migration[5.2]
  def up
    ActivitySequence.reindex
  end

  def def down 
    # irreversible migration
  end
end

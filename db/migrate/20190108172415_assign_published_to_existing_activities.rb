class AssignPublishedToExistingActivities < ActiveRecord::Migration[5.2]
  def up
    Activity.all.each do |activity|
      activity.status = :published
      activity.save
    end
  end

  def down
    # irreversible migration
  end
end

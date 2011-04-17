class AddSimpleTimes < ActiveRecord::Migration
  def self.up
    
    create_table 'simple_times' do |t|
      t.belongs_to :user
      t.belongs_to :project
      t.timestamps
      t.decimal :hours, :precision => 5, :scale => 2
      t.string :work
    end

    add_index "simple_times", ["project_id"]
    add_index "simple_times", ["user_id"]
      
  end

  def self.down
    drop_table 'simple_times'
  end

end

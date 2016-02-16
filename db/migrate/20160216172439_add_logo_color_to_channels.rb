class AddLogoColorToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :logo_color, :string
  end
end
  

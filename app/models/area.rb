class Area < ApplicationRecord
  has_many :restaurant

  def district
    if self.parent_id
      self.name + ", " + Area.find(self.parent_id).name
    else
      self.name
    end
  end

end
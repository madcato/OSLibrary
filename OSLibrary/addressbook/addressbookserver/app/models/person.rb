class Person < ActiveRecord::Base
  attr_accessible :avatar, :birthDate, :height, :name, :programmer, :objectId
  
  def objectId
    read_attribute(:id).to_s
  end
  
  def as_json(options={})
    result = super.as_json
    resul = result.merge({:objectId => self.objectId})
  end
end

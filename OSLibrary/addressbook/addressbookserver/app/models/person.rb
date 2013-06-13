class Person < ActiveRecord::Base
  attr_accessible :avatar, :birthDate, :height, :name, :programmer, :objectId
  
  def objectId
    read_attribute(:id).to_s
  end
  
  def as_json(options={})
    options.merge!({:except => [:id]})
    result = super.as_json(options)
    resul = result.merge({:objectId => self.objectId})
  end
end

class Service < ActiveRecord::Base
  validates_presence_of :name, :type
  validates :type,
    :inclusion => { :in => %w(Immediate Subscription Event Broadcast)}

  belongs_to :user
end

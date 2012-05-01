class Subscription < Service
  validates_presence_of :xquery, :start_time, :recurrence, :interval
end

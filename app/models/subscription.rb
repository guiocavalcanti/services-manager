class Subscription < Service
  validates_presence_of :xquery, :start_time, :recurrence, :interval

  protected

  def remote_params
    f_interval = self.interval.strftime("%H:%M:%S") if self.interval

    super.merge({
      'Xquery' => self.xquery,
      'StartTime' => self.start_time.try(:to_i),
      'Recurrence' => self.recurrence,
      'Interval' => f_interval,
      'Type' => self.class.to_s
    })
  end

end

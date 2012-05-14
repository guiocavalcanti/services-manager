class Immediate < Service
  validates_presence_of :xquery

  def remote_params
    super.merge({ 'Xquery' => self.xquery,
                  'Type' => self.class.to_s })
  end
end

class Service < ActiveRecord::Base
  validates_presence_of :name, :type
  validates :type,
    :inclusion => { :in => %w(Immediate Subscription Event Broadcast)}
  validate :create_on_webservice, :on => :create

  belongs_to :user

  protected

  def create_on_webservice(raise_errors=true)
    response = fire_create

    if response.success? && (result = Hash.from_xml(response.body))
      self.external_id = result['ServiceId']
    elsif raise_errors
      errors.add(:remote, "remote server error (#{response.status})")
    end
  end

  def fire_create
    connection.post('service') do |request|
      request.headers['Content-Type'] = 'application/xml'
      request.params = remote_params
    end
  end

  def connection
    url = ServiceManager::Application.config.task_manager_url
    @conn ||= Faraday.new(:url => url) do |builder|
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Response::Logger unless Rails.env.test?
      builder.use Faraday::Adapter::NetHttp
    end
  end

  def remote_params
    { 'Name' => self.name, 'Type' => self.type }
  end
end

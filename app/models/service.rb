class Service < ActiveRecord::Base
  validates_presence_of :name, :type
  validates :type,
    :inclusion => { :in => %w(Immediate Subscription Event Broadcast)}
  validate :create_on_webservice, :on => :create
  validate :update_on_webservice, :on => :update

  belongs_to :user

  protected

  def update_on_webservice(should_raise_errors=true)
    params = remote_params.merge({:Id => self.external_id})
    response = fire_request(:method => :put, :params => params)

    if !response.success?
      remote_error(response) if should_raise_errors
    end
  end

  def create_on_webservice(should_raise_errors=true)
    response = fire_request(:method => :post, :params => self.remote_params)

    if response.success?
      result = Hash.from_xml(response.body)

      unless result.blank?
        self.external_id = result['serviceCreateResponse']['serviceId']
      end
    else
      remote_error(response) if should_raise_errors
    end
  end

  def fire_request(opts)
    method = opts.delete(:method)
    params = opts.delete(:params)

    connection.send(method.to_sym, 'service') do |request|
      request.headers['Content-Type'] = 'application/xml'
      request.params = params
    end
  end

  def remote_error(response)
    errors.add(:remote, "remote server error (#{response.status})")
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

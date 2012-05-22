require 'spec_helper'

describe Subscription do
  let(:sample_response) do
    response = "<serviceCreateResponse><serviceId>12</serviceId></serviceCreateResponse>"
    {:status => 200, :body => response,
     :headers => { 'Content-type' => 'application/xml' }}
  end
  before { stub_request(:any, /108\.166\.91\.253/).to_return(sample_response) }

  context "validation" do
    let(:subscription) { Subscription.create }
    it "should validate xquery start_time recurrence interval" do
      %w(xquery start_time recurrence interval).each do |attr|
        subscription.errors.get(attr.to_sym) =~ /can't be blank/
      end
    end
  end

  context "remote" do
    it "should send correct params" do
      time = DateTime.now

      stub = stub_request(:post, "http://108.166.91.253:8080/webservices/rest/communicationService/service?Interval=23:59:59&Name=xim&Recurrence=1&StartTime=#{time.to_i}&Type=Subscription&Xquery=abc").
      with(:headers => {'Accept'=>'*/*', 'Content-Length'=>'0', 'Content-Type'=>'application/xml'}).to_return(sample_response)

      subscription = Subscription.new(:name => 'xim', :xquery => 'abc',
                                      :start_time => time, :recurrence => 1,
                                      :interval => Time.now.end_of_day)
      subscription.save
      stub.should have_been_requested
    end

  end
end

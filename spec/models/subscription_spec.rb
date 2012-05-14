require 'spec_helper'

describe Subscription do
  let(:sample_response) do
    response = "<ServiceId>12</ServiceId>"
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
      body = "Name=xim&Xquery=abc&StartTime=#{time.to_i}&Recurrence=1&Interval=23%3A59%3A59&Type=Subscription"

      stub = stub_request(:post, /108\.166\.91\.253/).
      with(:query => 'Interval=23:59:59&Name=xim&Recurrence=1&StartTime=1336649913&Type=Subscription&Xquery=abc').to_return(sample_response)

      subscription = Subscription.new(:name => 'xim', :xquery => 'abc',
                                      :start_time => time, :recurrence => 1,
                                      :interval => Time.now.end_of_day)
      subscription.save
      stub.should have_been_requested
    end

  end
end

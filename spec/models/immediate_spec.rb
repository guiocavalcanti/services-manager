require 'spec_helper'

describe Immediate do
  let(:sample_response) do
    response = "<serviceCreateResponse><serviceId>12</serviceId></serviceCreateResponse>"
    {:status => 200, :body => response,
     :headers => { 'Content-type' => 'application/xml' }}
  end
  before { stub_request(:any, /108\.166\.91\.253/).to_return(sample_response) }

  context "validations" do
    let(:subject) { Immediate.create }
    it "should validate presence of xquery" do
      subject.errors.get(:xquery).to_s.should =~ /can't be blank/
    end
  end

  context "remote" do
    it "should send correct params" do
      stub = stub_request(:post, 'http://108.166.91.253:8080/webservices/rest/communicationService/service?Name=xim&Type=Immediate&Xquery=abc').
        with(:hearders => {'Accept'=>'*/*', 'Content-Length'=>'0', 'Content-Type'=>'application/xml'}).
        to_return(sample_response)

      service = Immediate.new(:name => 'xim', :xquery => 'abc')
      service.save
      stub.should have_been_requested
    end
  end
end

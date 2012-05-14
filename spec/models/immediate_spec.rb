require 'spec_helper'

describe Immediate do
  let(:sample_response) do
    response = "<ServiceId>12</ServiceId>"
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
      stub = stub_request(:post, /108\.166\.91\.253/).
        with(:body => "Name=xim&Xquery=abc&Type=Immediate").
        to_return(sample_response)

      service = Immediate.new(:name => 'xim', :xquery => 'abc')
      service.save
      stub.should have_been_requested
    end
  end
end

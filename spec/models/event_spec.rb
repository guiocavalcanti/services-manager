require 'spec_helper'

describe Event do
  let(:sample_response) do
    response = "<ServiceId>12</ServiceId>"
    {:status => 200, :body => response,
     :headers => { 'Content-type' => 'application/xml' }}
  end
  before do
    stub_request(:any, /108\.166\.91\.253/).
      to_return(sample_response)
  end

  context "remote" do
    it "should send corrnt params" do
      stub = stub_request(:post, 'http://108.166.91.253:8080/webservices/rest/communicationService/service?Name=xim&Type=Event').
      with(:headers => {'Accept'=>'*/*', 'Content-Length'=>'0', 'Content-Type'=>'application/xml'}).
      to_return(sample_response)

      event = Event.new(:name => 'xim')
      event.save
      stub.should have_been_requested
    end
  end

end

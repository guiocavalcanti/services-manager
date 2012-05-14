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
      body = "Name=xim&Type=Event"

      stub = stub_request(:post, /108\.166\.91\.253/).
      with(:body => body).
      to_return(sample_response)

      event = Event.new(:name => 'xim')
      event.save
      stub.should have_been_requested
    end
  end

end

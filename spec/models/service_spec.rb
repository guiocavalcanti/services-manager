require 'spec_helper'

describe Service do
  let(:sample_response) do
    response = "<serviceCreateResponse><serviceId>12</serviceId></serviceCreateResponse>"
    {:status => 200, :body => response,
      :headers => { 'Content-type' => 'application/xml' }}
  end

  context "validation" do
    before { stub_request(:any, /108\.166\.91\.253/).to_return(sample_response) }
    let(:subject) { Service.create }

    it "should validate presence of" do
      %w(name type).collect(&:to_sym).each do |attr|
        subject.errors.should have_key(attr)
        subject.errors.get(attr).join(',').should =~ /can't be blank/
      end
    end

    it "should validate type" do
      subject.name = 'Ximbica'
      subject.type = 'User'
      subject.save

      subject.errors.get(:type).to_s.should =~ /included/
    end
  end

  context "relationships" do
    before { stub_request(:any, /108\.166\.91\.253/).to_return(sample_response) }
    let(:user) { User.create }
    let(:immediate) { Immediate.create(:name => 'ximbica', :xquery => 'yhoa') }

    it "should belong to a user" do
      user.services << immediate

      immediate.user.should == user
      user.services.should include immediate
    end
  end

  context "remote" do
    it "should not be valid if remote doesnt return status 200" do
     stub_request(:any, /108\.166\.91\.253/).to_return(:status => 500)

     service = Immediate.new(:name => 'xim', :xquery => 'abc')
     service.save
     service.errors.get(:remote).join(',').should =~ /remote server error \(500\)/
    end

    it "should assing externa_id when http code is 200" do
     stub_request(:any, /108\.166\.91\.253/).
       to_return(sample_response)

     service = Immediate.new(:name => 'xim', :xquery => 'abc')
     service.save
     service.external_id.should == 12
    end

    it "should not fail if response body is empty" do
      sample_response.merge!({:body => ''})
      stub_request(:any, /108\.166\.91\.253/).to_return(sample_response)

      expect {
        service = Immediate.new(:name => 'xim', :xquery => 'abc')
        service.save
      }.to_not raise_error(NoMethodError)
    end

    it "should not send any requests on update" do
      stub_request(:any, /108\.166\.91\.253/).
        to_return(sample_response)

      service = Immediate.new(:name => 'xim', :xquery => 'abc')
      service.should_receive(:create_on_webservice).once

      service.save
      service.update_attributes(:name => 'test')
    end

    it "should issue request when updating" do
      url = "http://108.166.91.253:8080/webservices/rest/communicationService/"
      stub_request(:any, /108\.166\.91\.253/).to_return(sample_response)

      service = Immediate.create(:name => 'xim', :xquery => 'abc')

      params = "Name=test&Type=Immediate&Xquery=abc&Id=#{service.external_id}"
      stub = stub_request(:put, "#{url}service?#{params}").
        to_return(:status => 200, :body => "", :headers => {})

      service.update_attributes(:name => 'test')

      stub.should have_been_requested.once
    end
  end
end

require 'spec_helper'

describe Immediate do
  context "validations" do
    let(:subject) { Immediate.create }
    it "should validate presence of xquery" do
      subject.errors.get(:xquery).to_s.should =~ /can't be blank/
    end
  end
end

require 'spec_helper'

describe Service do
  context "validation" do
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
    let(:user) { User.create }
    let(:immediate) { Immediate.create(:name => 'ximbica', :xquery => 'yhoa') }

    it "should belong to a user" do
      user.services << immediate

      immediate.user.should == user
      user.services.should include immediate
    end
  end
end

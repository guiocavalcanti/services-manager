require 'spec_helper'

describe Subscription do
  context "validation" do
    let(:subscription) { Subscription.create }
    it "should validate xquery start_time recurrence interval" do
      %w(xquery start_time recurrence interval).each do |attr|
        subscription.errors.get(attr.to_sym) =~ /can't be blank/
      end
    end
  end
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.delete_domain' do

  before(:all) do
    @sdb = Fog::AWS::SimpleDB.gen
    @domain_name = "fog_domain_#{Time.now.to_i}"
  end

  before(:all) do
    @sdb.create_domain(@domain_name)
  end

  it 'should return proper attributes' do
    actual = @sdb.delete_domain(@domain_name)
    actual.body['RequestId'].should be_a(String)
    actual.body['BoxUsage'].should be_a(Float)
  end

end
require 'spec_helper'
describe 'hhvm' do

  context 'with defaults for all parameters' do
    it { should contain_class('hhvm') }
  end
end

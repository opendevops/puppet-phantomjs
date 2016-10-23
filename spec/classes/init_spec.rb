require 'spec_helper'
describe 'phantomjs' do

  context 'with defaults for all parameters' do
    it { should contain_class('phantomjs') }
  end
end

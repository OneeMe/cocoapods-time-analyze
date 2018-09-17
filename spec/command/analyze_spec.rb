require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Analyze do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ analyze }).should.be.instance_of Command::Analyze
      end
    end
  end
end


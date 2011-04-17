require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  fixtures :projects

  before do 
    @project = projects(:retro)
  end

  it 'should have many simple_times' do
    @project.should have_many(:simple_times)
  end
end
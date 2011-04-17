require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :groups, :projects

  before do
    @user = User.new
  end

  it 'should have many simple_times' do
    @user.should have_many(:simple_times)
  end
  
  describe 'with the retro project' do
    before do
      Project.stub!(:current).and_return(projects(:retro))
    end
    
    describe 'Public user' do
      before do
        @user = users(:Public)
      end

      it 'should never be permitted to create times' do
        @user.send(:project_permission?, projects(:retro), :simple_times, :create).should be(true)      
        @user.send(:permitted?, :simple_times, :create).should be(false)      
      end
    end

    describe 'agent' do
      before do
        @user = users(:agent)
      end

      it 'should be permitted to create times' do
        @user.send(:permitted?, :simple_times, :create).should be(true)      
      end
    end
  end
  
end


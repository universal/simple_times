# coding:utf-8 
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SimpleTime do
  fixtures :users, :projects

  describe 'an instance' do

    before do 
      @time = SimpleTime.new
    end
  
    it 'should belong to project' do
      @time.should belong_to(:project)
    end
  
    it 'should belong to user' do
      @time.should belong_to(:user)
    end
  
  
    it 'should validate association of project' do
      @time.should validate_association_of(:project)
    end
  
    it 'should validate association of user' do
      @time.should validate_association_of(:user)
    end
  
    it 'should validate presence of hours' do
      @time.should validate_presence_of(:hours)
    end
  
    it 'should validate presence of work' do
      @time.should validate_presence_of(:work)
    end
    
    it 'should validate numericality of hours' do
      @time.should validate_numericality_of(:hours)
    end

  end

  describe 'before save' do

    before do 
      @time = SimpleTime.new
    end
    
    it 'should validate that assigned user is not public' do
      @time.user = users(:Public)
      @time.should have(1).error_on(:user_id)      
    end
        
  end

  describe 'before create' do

    before do
      User.stub!(:current).and_return(users(:agent))
      @time = SimpleTime.new
    end
    
    it 'should automatically assign the logged-in user' do
      @time.user.should be_nil      
      @time.valid?
      @time.user.should == users(:agent)      
    end
        
  end
end

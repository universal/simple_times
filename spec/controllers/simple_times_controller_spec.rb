require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SimpleTimesController do
  it_should_behave_like EveryProjectAreaController

  before do
    @project = permit_access_with_current_project! :name => 'Retro', :wiki_title => 'Retro'
    @user = stub_current_user! :permitted? => true, :projects => [@project]
    @times_proxy = @project.stub_association!(:simple_times)
    @times_proxy.stub!(:maximum)
    
    controller.stub!(:cached_user_attribute).with(:name, 'Anonymous').and_return('User Name')
    controller.stub!(:cached_user_attribute).with(:email).and_return('user@host.com')
  end

  describe 'GET /index' do
    
    before do
      @times = [mock_model(SimpleTime), mock_model(SimpleTime)]
      @times_proxy.stub!(:paginate).and_return(@times)
    end
    
    def do_get(options = {})
      get :index, options.merge(:project_id => @project.to_param)
    end
    
    it 'should check the freshness' do
      @times_proxy.should_receive(:maximum).with(:updated_at)
      do_get
    end
    
    it 'should load the times' do
      @times_proxy.should_receive(:paginate).with(
        :page => params[:page],
        :include => [:user],
        :per_page=>nil,
        :order=>'simple_times.created_at DESC',
        :total_entries=>nil
      ).and_return(@times) 
      do_get(:u => '1')
      assigns[:simple_times].should == @times 
    end

    it "should render the template" do
      do_get
      response.should be_success
      response.should render_template(:index)
    end

  end


  describe 'GET /show' do
    
    before do
      @simple_time = mock_model(SimpleTime, :updated_at => 10.minutes.ago)
      @times_proxy.stub!(:find).and_return(@simple_time)
    end
    
    def do_get(options = {})
      get :show, options.merge(:id => '1', :project_id => @project.to_param)
    end
    
    it 'should check the freshness' do
      @simple_time.should_receive(:updated_at)
      do_get
    end
  
    it 'should load the post' do
      @times_proxy.should_receive(:find).with('1', :include => [:user]).and_return(@simple_time)
      do_get
      assigns[:simple_time].should == @simple_time
    end
  
    it "should render the template" do
      do_get
      response.should be_success
      response.should render_template(:show)
    end
  
  end
  
  
  describe 'GET /new' do
    
    before do
      @simple_time = mock_model(SimpleTime)
      @times_proxy.stub!(:new).and_return(@simple_time)
    end
    
    def do_get(options = {})
      get :new, options.merge(:project_id => @project.to_param)
    end
  
    it 'should build the time' do
      @times_proxy.should_receive(:new).with(nil).and_return(@simple_time)
      do_get
      assigns[:simple_time].should == @simple_time
    end
  
    it "should render the template" do
      do_get
      response.should be_success
      response.should render_template(:new)
    end
    
  end
  
  
  describe 'POST /create' do
    
    before do
      @simple_time = mock_model(SimpleTime, :save => true)
      @times_proxy.stub!(:new).and_return(@simple_time)
    end
    
    def do_post
      post :create, :simple_time => {}, :project_id => @project.to_param
    end
  
    it 'should build the time' do
      @times_proxy.should_receive(:new).with({}).and_return(@simple_time)
      do_post
      assigns[:simple_time].should == @simple_time
    end
    
    describe 'when save is successful' do
      
      before do
        @simple_time.should_receive(:save).with().and_return(true)
      end      
  
      it 'should redirect to index' do
        do_post
        response.should redirect_to(project_simple_times_path(@project))
      end
  
    end
  
    describe 'when save is NOT successful' do
  
      before do
        @simple_time.should_receive(:save).and_return(false)        
      end      
  
      it "should render the new screen" do
        do_post
        response.should be_success
        response.should render_template(:new)
      end      
      
    end
    
  end
  
  
  describe 'GET /edit' do
    
    before do
      @simple_time = mock_model(SimpleTime)
      @times_proxy.stub!(:find).and_return(@simple_time)
    end
    
    def do_get(options = {})
      get :edit, options.merge(:id => '1', :project_id => @project.to_param)
    end
  
    it 'should load the post' do
      @times_proxy.should_receive(:find).with('1', :include => [:user]).and_return(@simple_time)
      do_get
      assigns[:simple_time].should == @simple_time
    end
  
    it "should render the template" do
      do_get
      response.should be_success
      response.should render_template(:edit)
    end      
    
  end
  
  
  describe 'PUT /update' do
    
    before do
      @simple_time = mock_model(SimpleTime, :update_attributes => true)
      @times_proxy.stub!(:find).and_return(@simple_time)
    end
    
    def do_put
      put :update, :id => '1', :simple_time => {}, :project_id => @project.to_param
    end
  
    it 'should load the post' do
      @times_proxy.should_receive(:find).with('1', :include => [:user]).and_return(@simple_time)
      do_put
      assigns[:simple_time].should == @simple_time
    end
  
    describe 'when update is successful' do
      
      it 'should redirect to index' do
        @simple_time.should_receive(:update_attributes).with({}).and_return(true)        
        do_put
        response.should redirect_to(project_simple_times_path(@project))
      end
            
    end
  
    describe 'when update is NOT successful' do
  
      it "should render the edit screen" do
        @simple_time.should_receive(:update_attributes).with({}).and_return(false)        
        do_put
        response.should be_success
        response.should render_template(:edit)
      end      
  
    end
    
  end
  
  
  describe 'DELETE /destroy' do
    
    before do
      @simple_time = mock_model(SimpleTime, :destroy => true)
      @times_proxy.stub!(:find).and_return(@simple_time)
    end
    
    def do_delete
      delete :destroy, :id => '1', :project_id => @project.to_param
    end
  
    it 'should load the page' do
      @times_proxy.should_receive(:find).with('1', :include => [:user]).and_return(@simple_time)
      do_delete
      assigns[:simple_time].should == @simple_time
    end
  
    it "should delete the record" do
      @simple_time.should_receive(:destroy).and_return(true)
      do_delete
    end
  
    it 'should redirect to index page' do
      do_delete
      response.should redirect_to(project_simple_times_path(@project))
    end
    
  end


end

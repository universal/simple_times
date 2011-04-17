require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SimpleTimesController do
  it_should_behave_like EveryProjectAreaController

  before do
    @project = permit_access_with_current_project! :name => 'Retro', :wiki_title => 'Retro'
    @user = stub_current_user! :permitted? => true, :projects => [@project]
    @times_proxy = @project.stub_association!(:simple_times)
    
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
    
    # it 'should check the freshness' do
    #   @times_proxy.should_receive(:maximum).with(:updated_at)
    #   do_get
    # end
    
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


  # describe 'GET /show' do
  #   
  #   before do
  #     @blog_post = mock_model(SimpleTime, :updated_at => 10.minutes.ago)
  #     @comment = mock_model(BlogComment)
  #     @comments_proxy = @blog_post.stub_association!(:comments, :new => @comment)      
  #     @times_proxy.stub!(:find).and_return(@blog_post)
  #   end
  #   
  #   def do_get(options = {})
  #     get :show, options.merge(:id => '1', :project_id => @project.to_param)
  #   end
  # 
  #   it 'should load the post' do
  #     @times_proxy.should_receive(:find).with('1', :include => [:categories, :user, :comments]).and_return(@blog_post)
  #     do_get
  #     assigns[:blog_post].should == @blog_post
  #   end
  # 
  #   it 'should prepare a comment' do
  #     @comments_proxy.should_receive(:new).with(:author => 'User Name', :email => 'user@host.com').and_return(@comment)
  #     do_get
  #   end
  #       
  #   it "should render the template" do
  #     do_get
  #     response.should be_success
  #     response.should render_template(:show)
  #   end
  # 
  # end
  # 
  # 
  # describe 'GET /new' do
  #   
  #   before do
  #     @blog_post = mock_model(SimpleTime)
  #     @times_proxy.stub!(:new).and_return(@blog_post)
  #   end
  #   
  #   def do_get(options = {})
  #     get :new, options.merge(:project_id => @project.to_param)
  #   end
  # 
  #   it 'should build the post' do
  #     @times_proxy.should_receive(:new).with(nil).and_return(@blog_post)
  #     do_get
  #     assigns[:blog_post].should == @blog_post
  #   end
  # 
  #   it "should render the template" do
  #     do_get
  #     response.should be_success
  #     response.should render_template(:new)
  #   end
  #   
  # end
  # 
  # 
  # describe 'POST /create' do
  #   
  #   before do
  #     @blog_post = mock_model(SimpleTime, :save => true)
  #     @times_proxy.stub!(:new).and_return(@blog_post)
  #   end
  #   
  #   def do_post
  #     post :create, :blog_post => {}, :project_id => @project.to_param
  #   end
  # 
  #   it 'should build the post' do
  #     @times_proxy.should_receive(:new).with({}).and_return(@blog_post)
  #     do_post
  #     assigns[:blog_post].should == @blog_post
  #   end
  #   
  #   describe 'when save is successful' do
  #     
  #     before do
  #       @blog_post.should_receive(:save).with().and_return(true)
  #     end      
  # 
  #     it 'should redirect to show' do
  #       do_post
  #       response.should redirect_to(project_blog_post_path(@project, @blog_post))
  #     end
  # 
  #   end
  # 
  #   describe 'when save is NOT successful' do
  # 
  #     before do
  #       @blog_post.should_receive(:save).and_return(false)        
  #     end      
  # 
  #     it "should render the new screen" do
  #       do_post
  #       response.should be_success
  #       response.should render_template(:new)
  #     end      
  #     
  #   end
  #   
  # end
  # 
  # 
  # describe 'GET /edit' do
  #   
  #   before do
  #     @blog_post = mock_model(SimpleTime)
  #     @times_proxy.stub!(:find).and_return(@blog_post)
  #   end
  #   
  #   def do_get(options = {})
  #     get :edit, options.merge(:id => '1', :project_id => @project.to_param)
  #   end
  # 
  #   it 'should load the post' do
  #     @times_proxy.should_receive(:find).with('1', :include => [:categories, :user, :comments]).and_return(@blog_post)
  #     do_get
  #     assigns[:blog_post].should == @blog_post
  #   end
  # 
  #   it "should render the template" do
  #     do_get
  #     response.should be_success
  #     response.should render_template(:edit)
  #   end      
  #   
  # end
  # 
  # 
  # describe 'PUT /update' do
  #   
  #   before do
  #     @blog_post = mock_model(SimpleTime, :update_attributes => true)
  #     @times_proxy.stub!(:find).and_return(@blog_post)
  #   end
  #   
  #   def do_put
  #     put :update, :id => '1', :blog_post => {}, :project_id => @project.to_param
  #   end
  # 
  #   it 'should load the post' do
  #     @times_proxy.should_receive(:find).with('1', :include => [:categories, :user, :comments]).and_return(@blog_post)
  #     do_put
  #     assigns[:blog_post].should == @blog_post
  #   end
  # 
  #   describe 'when update is successful' do
  #     
  #     it 'should redirect to show' do
  #       @blog_post.should_receive(:update_attributes).with({}).and_return(true)        
  #       do_put
  #       response.should redirect_to(project_blog_post_path(@project, @blog_post))
  #     end
  #           
  #   end
  # 
  #   describe 'when update is NOT successful' do
  # 
  #     it "should render the edit screen" do
  #       @blog_post.should_receive(:update_attributes).with({}).and_return(false)        
  #       do_put
  #       response.should be_success
  #       response.should render_template(:edit)
  #     end      
  # 
  #   end
  #   
  # end
  # 
  # 
  # describe 'DELETE /destroy' do
  #   
  #   before do
  #     @blog_post = mock_model(SimpleTime, :destroy => true)
  #     @times_proxy.stub!(:find).and_return(@blog_post)
  #   end
  #   
  #   def do_delete
  #     delete :destroy, :id => '1', :project_id => @project.to_param
  #   end
  # 
  #   it 'should load the page' do
  #     @times_proxy.should_receive(:find).with('1', :include => [:categories, :user, :comments]).and_return(@blog_post)
  #     do_delete
  #     assigns[:blog_post].should == @blog_post
  #   end
  # 
  #   it "should delete the record" do
  #     @blog_post.should_receive(:destroy).and_return(true)
  #     do_delete
  #   end
  # 
  #   it 'should redirect to index page' do
  #     do_delete
  #     response.should redirect_to(project_simple_times_path(@project))
  #   end
  #   
  # end


end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/simple_times/show.html.erb" do
  
  before(:each) do
    @project = stub_model(Project, :to_param => 'retro')
    @time = stub_model(SimpleTime, :work => 'Some previous wok', :hours => 2.0)
    Project.stub!(:current).and_return(@project)
    assigns[:time] = @time 
  end

  def do_render
    render "simple_times/show.html"
  end
    
  it "should render without errors"  
end


class SimpleTimesController < ProjectAreaController
  retrospectiva_extension('simple_times')

  menu_item :simple_times do |i|
    i.label = N_('SimpleTimes')
    i.rank = 30
    i.path = lambda do |project|
      project_simple_times_path(project)
    end
  end

  require_permissions :simple_times,
    :view    => ['index', 'show'],
    :create  => ['new', 'create'],
    :update  => ['edit', 'update'],
    :delete  => ['destroy']

  # before_filter :check_freshness_of_index, :only => [:index]
  before_filter :find_simple_time, :only => [:show, :comment, :edit, :update, :destroy]
  # before_filter :check_freshness_of_post, :only => [:show]
  # before_filter :load_categories, :only => [:index] 
  
  def index
    @simple_times = Project.current.simple_times.paginate options_for_paginate

    respond_to do |format|
      format.html
      format.rss  { render_rss(SimpleTime) }
    end
  end
  
  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @simple_time = Project.current.simple_times.new params[:simple_time]

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
    @simple_time = Project.current.simple_times.new params[:simple_time]

    respond_to do |format|
      if @simple_time.save
        flash[:notice] = _('SimpleTime was successfully created.')
        format.html { redirect_to project_simple_times_path(Project.current) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @simple_time.update_attributes(params[:simple_time])          
        flash[:notice] = _('Post was successfully updated.')      
        format.html { redirect_to [Project.current, @simple_time] }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @simple_time.destroy
    flash[:notice] = _('Post was successfully deleted.')
    
    respond_to do |format|
      format.html { redirect_to(project_simple_times_path(Project.current)) }
    end
  end

  protected 

    def find_simple_time
      @simple_time = Project.current.simple_times.find params[:id], :include => [:user]     
    end

    # def check_freshness_of_index
    #   fresh_when :last_modified => Project.current.simple_times.maximum(:updated_at)
    # end
    # 
    # def check_freshness_of_post
    #   fresh_when :etag => @simple_time, :last_modified => @simple_time.updated_at 
    # end

  private
  
    def options_for_paginate
      { :page => ( request.format.rss? ? 1 : params[:page] ), 
        :per_page => ( request.format.rss? ? 5 : nil ),
        :total_entries => ( request.format.rss? ? 5 : nil ),
        :include => [:user],
        :order => 'simple_times.created_at DESC' }
    end
end

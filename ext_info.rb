RetroAM.permission_map do |map|
  permitted_and_non_public = lambda { |project, user, has_permission, *records|
      has_permission and not user.public?
  }

  map.resource :simple_times, :label => N_('Times') do |times|
    times.permission :view,   :label => N_('View')
    times.permission :create, :label => N_('Create'), &permitted_and_non_public
    times.permission :update, :label => N_('Update'), &permitted_and_non_public
    times.permission :delete, :label => N_('Delete'), &permitted_and_non_public
    times.permission :modify, :label => N_('Modify'), &permitted_and_non_public
  end

end
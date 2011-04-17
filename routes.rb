#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
RetroEM::Routes.draw do |map|

  map.resources :projects do |project|
    project.resources :simple_times
  end
  
end

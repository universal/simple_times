RetroEM::Routes.draw do |map|

  map.resources :projects do |project|
    project.resources :simple_times
  end
  
end

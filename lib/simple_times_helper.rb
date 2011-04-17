module SimpleTimesHelper

  def include_simple_times_stylesheet
    content_for :header do
      x_stylesheet_link_tag('simple_times')      
    end
  end

end

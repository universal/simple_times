Project.class_eval do
  has_many :simple_times, :dependent => :destroy
end

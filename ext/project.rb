#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
Project.class_eval do
  has_many :simple_times, :dependent => :destroy
end

class SimpleTime < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_association_of :project
  validates_association_of :user
  validate :user_not_public
  validates_presence_of :hours, :work

  protected
    def user_not_public
      if user and user.public?
        errors.add :user_id, 'cannot be public'
      end
    end
    
    def before_validation_on_create
      self.user = User.current unless User.current.public?
      true
    end
end

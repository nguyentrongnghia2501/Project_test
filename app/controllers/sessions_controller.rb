class SessionsController < Devise::SessionsController
   def create
    super do |resource|
      if resource.persisted?
        UserMailer.confirmation_instructions(resource).deliver_now
      end
    end
  end
  def new
    super
  end

  def create
    super
  end

  def destroy
 
    super
  end
   private

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) 
    your_custom_path 
  end
end

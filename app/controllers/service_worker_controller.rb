class ServiceWorkerController < ApplicationController
  protect_from_forgery except: :service_worker
  #  skip_before_action :authenticate_user! - To activate if Devise
  
  def service_worker
  end
  
  def manifest
  end
  
  def offline
  end
  
end

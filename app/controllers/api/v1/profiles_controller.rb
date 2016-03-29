class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    other_users = User.where.not(id: current_resource_owner)
    respond_with other_users
  end
end

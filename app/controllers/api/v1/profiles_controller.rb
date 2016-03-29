class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, User

    respond_with current_resource_owner
  end

  def index
    authorize! :read, User

    other_users = User.where.not(id: current_resource_owner)
    respond_with other_users
  end
end

class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with other_users
  end

  private

  def other_users
    @users = User.where.not(id: current_resource_owner.id) if current_resource_owner
  end
end
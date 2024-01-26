class UsersController < ApplicationController
  before_action :set_task, only: %i[destroy ]

  def index
    users = params[:query].blank? ? User.all : User.where("full_name iLIKE ?", "%#{params[:query]}%")
    @users = users.paginate(page: params[:page], per_page: 15)
    @daily_record = DailyRecord.all
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "User was successfully destroyed." }
    end
  end

  private
  
  def set_task
    @user = User.find(params[:id])
  end
end

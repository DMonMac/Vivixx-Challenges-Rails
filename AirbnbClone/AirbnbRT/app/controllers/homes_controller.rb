class HomesController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    if logged_in?
      @home = current_user.homes.build
    end
  end

  def index
    if params[:search].present?
      @homes = Home.near(params[:search], 50)
    else
      @homes = Home.all
    end
  end

  def show
    @home = Home.find(params[:id])
  end


  def create
    @home = current_user.homes.build(home_params)
    if @home.save
      flash[:success] = "Successfully added home: #{@home.name}"
      redirect_to user_url(@home.user_id)
    else
      @feed_items = []
      render 'new'
    end
  end

  def edit
  end

  def update
    if @home.update_attributes(home_params)
      # Action after successful edit
      flash[:sucess] = "Home updated"
      redirect_to @home
    else
      render 'edit'
    end
  end

  def destroy
    @home.destroy
    flash[:success] = "Home removed."
    redirect_to request.referrer || user_url
  end

  private

  def home_params
    params.require(:home).permit(:name,
                                 :address,
                                 :latitude,
                                 :longitude,
                                 :description,
                                 :price,
                                 :picture)
  end

  def correct_user
    @home = current_user.homes.find_by(id: params[:id])
    redirect_to home_url if @home.nil?
  end

end

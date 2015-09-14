class UsersController < AccessController
  before_action :authenticate, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @current_user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if User.exists?(username: @user.username) || User.exists?(email: @user.email)
       render :template=>"users/error.json.jbuilder",locals:{message: "Username or Email already exists"},:success => true, :status => :ok ,:formats => [:json]
    else
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        render :template=>"users/error.json.jbuilder",locals:{message: "An error occured"},:success => true, :status => :ok ,:formats => [:json]
      end
    end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(current_user.id)
    respond_to do |format|
    if @user.update_attributes(params.require(:user).permit(:email,:password))
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
    else
         render :template=>"users/error.json.jbuilder",locals:{message: "Invalid"},:success => true, :status => :ok ,:formats => [:json]
    end  
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    current_user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   def login
      #authenticate_or_request_with_http_basic do |username, password|
       #Rails.logger.info "API authentication:#{username} #{password}"
        if User.exists?(username: params[:username], password: params[:password])
         @user = User.find_by_username(params[:username])
         render :template=>"users/show.json.jbuilder", :status=> :ok, localion:@user,:formats => [:json]
        else
          render :template=>"users/error.json.jbuilder",locals:{message: "Wrong Username or Password"},:success => true, :status => :ok ,:formats => [:json]
        end   
    end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username,:email,:password)
    end
end

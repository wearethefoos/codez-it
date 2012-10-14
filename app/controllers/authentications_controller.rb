class AuthenticationsController < ApplicationController
  authorize_resource

  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.admin? ?
      Authentication.all :
      current_user.authentications

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # GET /authentications/1
  # GET /authentications/1.json
  def show
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/new
  # GET /authentications/new.json
  def new
    @authentication = Authentication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/1/edit
  def edit
    @authentication = Authentication.find(params[:id])
  end

  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if authentication
      flash[:notice] = t(:signed_in)
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications << Authentication.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t(:success)
      redirect_to authentications_url
    elsif user = create_new_omniauth_user(omniauth)
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t(:welcome)
      sign_in_and_redirect(:user, user)
    else
      flash[:alert] = t(:fail)
      redirect_to new_user_registration_url
    end
  end

  # PUT /authentications/1
  # PUT /authentications/1.json
  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = t(:successfully_destroyed_authentication)
    redirect_to authentications_url
  end

  private

    def create_new_omniauth_user(omniauth)
      user = User.new
      user.apply_omniauth(omniauth)
      return user if user.save
      nil
    end
end

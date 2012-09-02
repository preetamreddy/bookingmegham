class AccountSettingsController < ApplicationController
  load_and_authorize_resource
  # GET /account_settings
  # GET /account_settings.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @account_settings }
    end
  end

  # GET /account_settings/1
  # GET /account_settings/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account_setting }
    end
  end

  # GET /account_settings/new
  # GET /account_settings/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account_setting }
    end
  end

  # GET /account_settings/1/edit
  def edit
  end

  # POST /account_settings
  # POST /account_settings.json
  def create
    respond_to do |format|
      if @account_setting.save
        format.html { redirect_to @account_setting, notice: 'Account setting was successfully created.' }
        format.json { render json: @account_setting, status: :created, location: @account_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @account_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /account_settings/1
  # PUT /account_settings/1.json
  def update
    respond_to do |format|
      if @account_setting.update_attributes(params[:account_setting])
        format.html { redirect_to @account_setting, notice: 'Account setting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @account_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_settings/1
  # DELETE /account_settings/1.json
  def destroy
    @account_setting.destroy

    respond_to do |format|
      format.html { redirect_to account_settings_url }
      format.json { head :ok }
    end
  end
end

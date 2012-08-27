class PropertiesController < ApplicationController
	load_and_authorize_resource
  # GET /properties
  # GET /properties.json
  def index
		property_name = params[:name]
		property_name ||= ''
		property_name = property_name.downcase

		city = params[:city]
		city ||= ''
		city = city.downcase

    @properties = @properties.paginate(page: params[:page], per_page: 10).
      order('ensure_availability_before_booking desc, name').
			find(:all, :conditions => [ 'lower(name) like ? and lower(city) like ?',
				"%" + property_name + "%", "%" + city + "%" ])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @properties }
    end
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @property }
    end
  end

  # GET /properties/new
  # GET /properties/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @property }
    end
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties
  # POST /properties.json
  def create
    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: 'Property was successfully created.' }
        format.json { render json: @property, status: :created, location: @property }
      else
        format.html { render action: "new" }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.json
  def update
    respond_to do |format|
      if @property.update_attributes(params[:property])
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url, alert: @property.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

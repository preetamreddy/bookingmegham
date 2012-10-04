class TooltipsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :tooltip_content 
  # Add admin before_filter here - something like this (depends on your authorization solution)
  # This prevents regular users from modifying the help pages
  # before_filter admin?, :except => [ :tooltip_content ]
  
  # GET /tooltips
  # GET /tooltips.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tooltips }
    end
  end

  # GET /tooltips/1
  # GET /tooltips/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tooltip }
    end
  end

  # GET /tooltips/new
  # GET /tooltips/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tooltip }
    end
  end

  # GET /tooltips/1/edit
  def edit
  end

  # POST /tooltips
  # POST /tooltips.xml
  def create
    respond_to do |format|
      if @tooltip.save
        format.html { redirect_to(@tooltip, :notice => 'Tooltip was successfully created.') }
        format.xml  { render :xml => @tooltip, :status => :created, :location => @tooltip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tooltip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tooltips/1
  # PUT /tooltips/1.xml
  def update
    respond_to do |format|
      if @tooltip.update_attributes(params[:tooltip])
        format.html { redirect_to(@tooltip, :notice => 'Tooltip was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tooltip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tooltips/1
  # DELETE /tooltips/1.xml
  def destroy
    @tooltip.destroy

    respond_to do |format|
      format.html { redirect_to(tooltips_url) }
      format.xml  { head :ok }
    end
  end
  
  # fetch and return the content of the specified tooltip, taking into account user's locale where relevant
  def tooltip_content
    @tooltip = Tooltip.from_title_and_locale(params[:title])

    if params[:js]
      if @tooltip.blank?
        data = "Sorry... unable to find the help content"
      else
        data = @tooltip.content_to_html
      end
      send_data(data, :type => 'text/plain', :disposition => 'inline')
    end
  end
end

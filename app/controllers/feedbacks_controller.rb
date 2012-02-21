class FeedbacksController < ApplicationController
  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.paginate(page: params[:page], per_page: 5).
									order('criticality, priority, status, model, view').
									all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
		begin
    	@feedback = Feedback.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid feedback #{params[:id]}"
			redirect_to feedbacks_url, notice: 'Invalid Feedback'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @feedback }
			end
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
		begin
    	@feedback = Feedback.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid feedback #{params[:id]}"
			redirect_to feedbacks_url, notice: 'Invalid Feedback'
		end
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :ok }
    end
  end
end

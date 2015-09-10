class EventsController < AccessController
  before_action :authenticate

  # GET /events
  # GET /events.json
  def index
     @j = UserEvent.where(user_id: current_user.id)
      @u = []
    @j.each do |j|
      @u <<j.event_id
    end
    @event = Event.where.not(id: @u).where.not(username:current_user.username)
    render :template=>"events/index.json.jbuilder", :status=> :ok, locals: { events: @event}, :formats => [:json]
  end

  # GET /events/1
  # GET /events/1.json
  def show
    event = Event.find(params[:id])
  end
    
  
  def view
    @j = UserEvent.where(user_id: current_user.id)
      @u = []
    @j.each do |j|
      @u <<j.event_id
    end  
      @event= Event.where(id: @u).where.not(username:current_user.username)
    render :template=>"events/index.json.jbuilder", :status=> :ok, locals: { events: @event}, :formats => [:json]
   
  end

  def myevents
    @event = Event.where(username: current_user.username)
    render :template=>"events/index.json.jbuilder", :status=> :ok, locals: { events: @event}, :formats => [:json]
  end
  

  def going
    @event = Event.find_by_name(params[:name])
    if UserEvent.exists?(user_id: current_user.id, event_id: @event.id)
      #render :template=>"events/index.json.jbuilder", :status=> :ok, locals: { events: @event}, :formats => [:json]
    else
      @j = UserEvent.new
      @event.user_events << @j
      current_user.user_events << @j
      #render :template=>"events/index.json.jbuilder", :status=> :ok, locals: { events: @event}, :formats => [:json]
    end
  end


  # GET /events/new
  def new
    event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @j = UserEvent.new
    @event = Event.new(event_params)
    @event.username = current_user.username
  
  respond_to do |format|
    if @event.save
      @event.user_events << @j
      current_user.user_events << @j
      format.html { redirect_to event, notice: 'Event was successfully created.' }
      format.json { render :show, status: :created, location: @event }
    else
      format.html { render :new }
      format.json { render json: @event.errors, status: :unprocessable_entity }
    end 
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
      @event = Event.find(params[:id])
    respond_to do |format|
    if Event.exists?(username: current_user.username , id: @event.id)
      format.json { render json: @event.errors, status: :unprocessable_entity }
    else
     if @event.update(event_params)
       format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
     else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
     end
     end
   end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name,:date,:description,:location)
    end
end

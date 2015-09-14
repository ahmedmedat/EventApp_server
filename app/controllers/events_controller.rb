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
  end

  def watch
     @event = Event.find_by_name(params[:name])
    # @event = Event.find(params[:id])
    render :template=>"events/show.json.jbuilder", :status=> :ok, :formats => [:json]

  end

  def search
    @event = Event.where(name: params[:name])
    render :template=>"events/index.json.jbuilder", :status=> :ok, locals: { events: @event}, :formats => [:json]
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
    @event = Event.find(params[:id])
    if UserEvent.exists?(user_id: current_user.id, event_id: @event.id)
      render :template=>"events/message.json.jbuilder",locals:{message: "you already joined"},:success => true, :status => :ok ,:formats => [:json]
    else
      @j = UserEvent.new
      @event.user_events << @j
      current_user.user_events << @j
      render :template=>"events/message.json.jbuilder",locals:{message: "you are welcome"},:success => true, :status => :ok ,:formats => [:json]
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
      render :template=>"events/message.json.jbuilder",locals:{message: "an error occurred"},:success => true, :status => :ok ,:formats => [:json]      
    end 
    end
  end

  # PATCH/PUT /event_update
  # PATCH/PUT /event_update.json
  def update
      @event = Event.find(params[:id])
    if Event.exists?(username: current_user.username , id: @event.id)
       if @event.update(event_params)
        render :template=>"events/show.json.jbuilder", :status=> :ok, :formats => [:json]
       else
        render :template=>"events/message.json.jbuilder",locals:{message: "an error occurred"},:success => true, :status => :ok ,:formats => [:json]      
       end
    else
      render :template=>"events/message.json.jbuilder",locals:{message: "an error occurred"},:success => true, :status => :ok ,:formats => [:json]        
    end

  end

  # DELETE /event_delete
  # DELETE /event_delete.json
  def destroy
    @event = Event.find(params[:id])
    if Event.exists?(username: current_user.username , id: @event.id)
    @event.destroy
    render :template=>"events/message.json.jbuilder",locals:{message: "successfully deleted"},:success => true, :status => :ok ,:formats => [:json]      
    else
     render :template=>"events/message.json.jbuilder",locals:{message: "an error occurred"},:success => true, :status => :ok ,:formats => [:json]      
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

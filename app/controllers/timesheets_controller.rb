class TimesheetsController < ApplicationController
  load_and_authorize_resource

  # GET /timesheets
  # GET /timesheets.json
  def index
    if current_user.is? :admin
      @timesheets = Timesheet.where(:submitted => true)
    else
      @timesheets = current_user.timesheets
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timesheets }
    end
  end

  # GET /timesheets/1
  # GET /timesheets/1.json
  def show
    @timesheet = Timesheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timesheet }
    end
  end

  # GET /timesheets/new
  # GET /timesheets/new.json
  def new
    @timesheet = Timesheet.new
    @timesheet.start_date = Date.parse('Monday')
    if current_user.is? :admin
      @user_change_disabled = false
    else
      @timesheet.user = current_user
      @user_change_disabled = true
    end

    7.times {@timesheet.time_entries.build}
    @time_entries = @timesheet.time_entries


    (0..6).each do |i|
      @time_entries[i].day = i
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timesheet }
    end
  end

  # GET /timesheets/1/edit
  def edit
    @timesheet = Timesheet.find(params[:id])
    @time_entries = @timesheet.time_entries.order(:day)
    @user_change_disabled = true  #### based of if current user is a ra or admin.
    output = []
    k = 0
    (0..6).each do |i|
      if @time_entries[k] and @time_entries[k].day == i
        output << @time_entries[k]
        k += 1
      else
         b = @time_entries.build
         b.day = i
         output << b
      end
    end
    @time_entries = output
  end

  # POST /timesheets
  # POST /timesheets.json
  def create
    @timesheet = Timesheet.new(params[:timesheet])
    @timesheet.submitted = params[:draft].nil?
    @timesheet.user ||= current_user

    respond_to do |format|
      if @timesheet.save
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully created.' }
        format.json { render json: @timesheet, status: :created, location: @timesheet }
      else
        format.html { render action: "new" }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /timesheets/1
  # PUT /timesheets/1.json
  def update
    @timesheet = Timesheet.find(params[:id])
    @timesheet.submitted = params[:draft].nil?

    respond_to do |format|
      if @timesheet.update_attributes(params[:timesheet])
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timesheets/1
  # DELETE /timesheets/1.json
  def destroy
    @timesheet = Timesheet.find(params[:id])
    @timesheet.destroy

    respond_to do |format|
      format.html { redirect_to timesheets_url }
      format.json { head :no_content }
    end
  end

  def approve
    @timesheet = Timesheet.find(params[:id])
    @timesheet.approver = current_user
    @timesheet.save
    redirect_to timesheets_path
  end
end

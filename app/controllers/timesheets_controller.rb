class TimesheetsController < ApplicationController
  load_and_authorize_resource

  # GET /timesheets
  # GET /timesheets.pdf
  def index
    if params[:format] == 'pdf'
      if params[:type] == "Not Printed"
        @timesheets = Timesheet.not_printed
        @timesheets.each { |timesheet| timesheet.printing }
      else
        @timesheets = Timesheet.approved
      end
    elsif current_user.is? :admin
      @timesheets = current_user.timesheets.not_submitted + Timesheet.submitted
    else
      @timesheets = current_user.timesheets
    end

    respond_to do |format|
      format.html # index.html.erb
      format.pdf do
        render :pdf => "index.pdf.erb", :header => {:right => '[page] of [topage]'},
               :layout => 'pdf', :orientation => 'Landscape'
      end
    end
  end

  # GET /timesheets/1
  # GET /timesheets/1.pdf
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => "show.pdf.erb", :header => {:right => '[page] of [topage]'},
               :layout => 'pdf', :orientation => 'Landscape'
      end
    end
  end

  # GET /timesheets/new
  def new
    @timesheet.start_date = Date.parse('Monday')
    @user_change_disabled = (not current_user.is? :admin )

    if @user_change_disabled
      @timesheet.user = current_user
    end

    7.times { @timesheet.time_entries.build }
    @time_entries = @timesheet.time_entries


    (0..6).each do |i|
      @time_entries[i].day = i
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /timesheets/1/edit
  def edit
    @time_entries = @timesheet.time_entries.order(:day)
    @user_change_disabled = true #### based of if current user is a ra or admin.
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
  def update
    @timesheet.submitted = params[:draft].nil?
    if @timesheet.update_attributes(params[:timesheet])
      format.html { redirect_to @timesheet, notice: 'Timesheet was successfully updated.' }
    else
      format.html { render action: "edit" }
    end
  end

  # DELETE /timesheets/1
  def destroy
    @timesheet.destroy

    respond_to do |format|
      format.html { redirect_to timesheets_url }
      format.json { head :no_content }
    end
  end

  def approve
    @timesheet.approver= current_user
    @timesheet.save
    redirect_to timesheets_path
  end

  def send_timesheet_reminder
    if current_user.is? :admin
      TimesheetMailer.timesheet_reminder(current_user).deliver
      redirect_to root_url, notice: "Reminder Sent"
    else
      redirect_to root_url, notice: "Unauthorized"
    end
  end
end

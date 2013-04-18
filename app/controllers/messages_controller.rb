class MessagesController < ApplicationController
  load_and_authorize_resource


  def new
    @message = Message.new
    if current_user.has_role? :admin
      @projects = Project.all
    else
      @projects = Project.all.select { |p| current_user.has_role? :researcher, p }
    end
  end

  def create
    @message = Message.new(params[:message])
    @message.from_user = current_user
    if @message.save
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render action: 'new'
    end
  end
end

class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :from_user, :content, :project_id

  # Creates record and uses active record like hash assignment for variables.
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # The save method does not save message to a database. Instead
  # a message is emailed to moderators.
  #
  # If project_id == 0 we assume they are contacting us for site design.
  # -In this case we email all admins.
  #
  # Otherwise we lookup the project the user selects.
  # -In this case we email the user responsible for the project.
  def save
    if project_id.to_i > 0
      project = Project.find(project_id)
    else
      project = nil
    end

    if project.nil?
      UserMailer.send_email_to_list(from_user,
                                    User.with_role(:admin),
                                    "WCAI contact form for site design",
                                    content).deliver
    else
      UserMailer.send_email_to_list(from_user,
                                    [project.user],
                                    "WCAI contact form for #{project.name} project",
                                    content).deliver
    end
  end

  # Not saved to database.
  # Not sure if this function is needed. I don't use it.
  def persisted?
    false
  end
end
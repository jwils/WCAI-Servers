class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :from_user, :content, :project_id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save
    if project_id.to_i > 0
      project = Project.find(project_id)
    else
      project = nil
    end

    if project.nil?
      UserMailer.send_email_to_list(from_user,
                                    User.with_role(:admin),
                                    "WCAI contact form for site design" ,
                                    content).deliver
    else
      UserMailer.send_email_to_list(from_user,
                                    [project.user],
                                    "WCAI contact form for #{project.company.name} project",
                                    content).deliver
    end
  end

  def persisted?
    false
  end
end
class DatepickerInput < SimpleForm::Inputs::Base
  def input
    input_html_options[:value] ||= @builder.object.send(attribute_name).strftime("%m/%d/%Y") unless @builder.object.send(attribute_name).nil?
    @builder.text_field(attribute_name, input_html_options) + \
    @builder.hidden_field(attribute_name, { :class => attribute_name.to_s + "-alt"})
  end
end
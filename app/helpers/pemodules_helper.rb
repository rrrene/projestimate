module PemodulesHelper

  def display_attribute_rule(attr, module_attr=nil)
    title = String.new
    title << "#{I18n.t(:tooltip_attribute_rules)} : <strong>#{attr.options.join(' ')} </strong> <br> "
    unless module_attr.nil?
      title << "#{I18n.t(:mandatory)} : #{I18n.t(module_attr.is_mandatory)}"
    end
    title
  end
end
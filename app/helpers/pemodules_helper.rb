module PemodulesHelper

  def display_attribute_rule(attr)
    "<br> #{I18n.t(:tooltip_attribute_rules)}: <strong>#{attr.options.join(' ')} </strong> <br> "
  end
end
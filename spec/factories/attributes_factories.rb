#
##Attributes
#FactoryGirl.define do
#
#  attributes = [
#  ["KSLOC", "ksloc", "Kilo Size Line Of Code.", "integer", [], "sum"],
#    ["Cost", "cost", "Cost of a product, a service or a processus.", "integer", [], "sum"],
#    ["Delay", "delay", "Time allowed for the completion of something.", "integer", [], "average"],
#    ["Staffing", "staffing", "Staff required to accomplish a task", "integer", [], "sum"],
#    ["Staffing complexity", "staffing_complexity", "A rating of the project's inherent difficulty in terms of the rate at which staff are added to a project.", "integer", [], "average"],
#    ["Effective technology", "effective_technology", "A composite metric that captures factors relating to the efficiency or productivity with which development can be carried out.", "integer", [], "average"],
#    ["End date", "end_date", "End date for a task, a component. Dependent of delay.", "date", [], "maxi"],
#    ["Effort", "effort", "Effort in Man-Months", "integer", [], "average"],
#    ["Duration", "duration", "Duration of a task", "integer", [], "average"],
#    ["Complexity", "complexity", "Application complexity (for COCOMO modules)", "integer", [], "average"],
#  ]
#
#  sequence :factory_name do |n|
#    "#{attributes[n][1]}"
#  end
#
#  sequence :name do |n|
#    "#{attributes[n][0]}"
#  end
#
#  sequence :alias do |n|
#    "#{attributes[n][1]}"
#  end
#
#  #attributes.each do |i|
#  #  factory :"#{i[1]}_attribute", :class => Attribute do |attr|
#  #    attr.name         "#{i[0]}"
#  #    attr.alias        "#{i[1]}"
#  #    attr.description  "#{i[2]}"
#  #    attr.attr_type    "#{i[3]}"
#  #    attr.with_options "#{i[4]}"
#  #    attr.aggregation  "#{i[5]}"
#  #  end
#  #end
#
#end
#
## Acquisition categories
#
#FactoryGirl.define do
#
#  #Default acquisition category
#  acquisition_category = Array.new
#  acquisition_category = [
#    ["Unknown","TBD"],
#    ["New_Development","TBD"],
#    ["Enhancement","TBD"],
#    ["Re_development","TBD"],
#    ["POC","TBD"],
#    ["Purchased","TBD"],
#    ["Porting","TBD"],
#    ["Other","TBD"]
#  ]
#
#  acquisition_category.each do |ac|
#    factory ":#{ac[0]}_acquisition_categort", :class => AcquisitionCategory do
#      name "#{ac[0]}"
#      description "#{ac[1]}"
#    end
#  end
#
#
#end
FactoryGirl.define do

  factory :event, :class => Event do
    name  'Event1'
    description 'Event number 1'
    start_date nil
    end_date nil
    event_type_id nil
    project_id nil
  end

end

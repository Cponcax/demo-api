class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :name, :days
end

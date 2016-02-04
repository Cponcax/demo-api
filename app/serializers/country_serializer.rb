class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :alpha2, :alpha3
end

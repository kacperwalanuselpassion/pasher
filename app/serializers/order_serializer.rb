class OrderSerializer < ActiveModel::Serializer
  self.root = false


  attributes :_id, :name, :ordered_at, :founder, :dishes

  def founder
    founder = User.where(uid: object.founder_uid).first
    {
      uid: founder.uid,
      name: founder.name
    }
  end
end

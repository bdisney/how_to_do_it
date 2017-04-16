class AttachmentSerializer < ActiveModel::Serializer
  attributes :name, :src
  
  def name
    object.file.identifier
  end
  
  def src
    object.file.url
  end
end
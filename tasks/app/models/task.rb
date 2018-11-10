class Task < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :name,:attachment, presence: true
end

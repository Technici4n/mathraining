class Submissionfile < ActiveRecord::Base
  attr_accessible :file, :submission_id
  has_attached_file :file,
    :path => ':rails_root/public/system/:attachment/:class/:id/:basename_:hash.:extension',
    :url => '/system/:attachment/:class/:id/:basename_:hash.:extension',
    :hash_secret => "longSecretString"
  belongs_to :submission
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 10.megabytes
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp', 'application/pdf', 'application/zip', 'application/msword', 'text/plain']
  
  def is_image
   if self.file.content_type == 'image/jpeg' || self.file.content_type == 'image/jpg' || self.file.content_type == 'image/png' || self.file.content_type == 'image/gif' || self.file.content_type == 'image/bmp'
     return true
   else
     return false
   end
  end
end

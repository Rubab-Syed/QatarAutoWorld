class Photo < ActiveRecord::Base
  belongs_to :room
  has_many :photos

  # has_attached_file :image
  has_attached_file :image, styles: { medium: "363x242>", thumb: "100x100#" },
  :convert_options => {
    :thumb => "-quality 75 -strip" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_presence :image, presence: true
  validates_attachment_size :image, :less_than => 100.kilobytes, :unless => Proc.new {|m| m[:image].nil?}
end

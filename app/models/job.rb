class Job < ApplicationRecord
  validates :title, presence: { message: "請填寫職位"}
  validates :wage_lower_bound, presence: { message: "請填寫低薪資"}
  validates :wage_upper_bound, presence: { message: "請填寫最高薪資"}
  validates :wage_lower_bound, numericality: { greater_than: 0, message: "最小薪資必須大於0"}
  validates :wage_lower_bound, numericality: { less_than: :wage_upper_bound, message: "薪資上限必須大於薪資下限"}
  validates :company, presence: { message: "請填寫公司名稱" }
  validates :category, presence: { message: "請選擇工作類型" }
  validates :location, presence: { message: "請選擇工作地點" }
  #正則寫法 /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  # com matches /[a-z]{2,}/
  # mydomain.example. matches /(?:[-a-z0-9]+\.)+/
  #  validates_format_of :contact_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i , message: "请输入正确的邮箱格式"

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end


  scope :published, -> {  where(is_hidden: false) }
  scope :recent, -> {  order('created_at DESC') }
  scope :category, -> { order('category')}

  has_many :resumes
  has_many :favorites
  has_many :members, through: :favorites, source: :user


end

class Book < ApplicationRecord
  belongs_to :author
 
  validates_presence_of :title
  validates_length_of :title, maximum: 255
  validates_presence_of :year
  validates_numericality_of :year, only_integer: true, greater_than: 0, less_than: 2500  
  validates :is_fiction, inclusion: [true, false]

    
  # Order books by year, author.name, or title
  def self.order_by field
      
    if field == 'year'
      return Book.order(:year, :title)
    elsif field == 'author'
      return Book.joins(:author).order(:name, :year)
    elsif field == 'genre'
        return Book.order(is_fiction: :desc, title: :asc)
    else
      return Book.order(:title)
    end
  end
    
    
    def genre
        
        if is_fiction == true
            return "fiction"
            
        else
            return "nonfiction"
        end
    end
end

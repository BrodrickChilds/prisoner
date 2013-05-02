module ApplicationHelper
  def sortable(column, title = nil)  
    title ||= column.titleize  
    direction = (column == params[:sort] && params[:order] == "asc") ? "desc" : "asc"  
    link_to title, :sort => column, :order => direction  
  end 
end

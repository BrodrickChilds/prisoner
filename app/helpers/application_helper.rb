module ApplicationHelper
  def sortable(column, title = nil)  
    title ||= column.titleize  
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil  
    direction = (column == params[:sort] && params[:order] == "asc") ? "desc" : "asc"  
    content = title + "<i class='icon-caret-down'></i>" + "<i class='icon-caret-up'></i>"
    link_to content.html_safe, {:sort => column, :order => direction, :facebook => params[:facebook], :completed => params[:completed]}, {:class => css_class}
  end 
end

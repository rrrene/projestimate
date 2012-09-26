module SearchesHelper
  def display_result(res, params)
    link_to raw("#{ res.to_s.gsub(/(#{params})/i, '<strong>\1</strong>')}") , "/#{String::keep_clean_space(res.class.to_s.underscore.pluralize)}/#{res.id}/edit" , :class => "search_result"
  end
end

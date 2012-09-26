module UsersHelper
  def build_find_use_user_popup(user_id)
      user = User.find(user_id)
      title = content_tag(:p, "Relationships with #{user} :")
      li = String.new
      user.projects.each do |user_project|
        li << content_tag(:li, user_project.title)
      end

      res = "
              #{title}
              <ul>
                #{li}
              </ul>
            "
      return res
  end
end

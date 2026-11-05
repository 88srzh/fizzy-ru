module UsersHelper
  def role_display_name(user)
    case user.role
    when "admin" then "Администратор"
    else user.role.titleize
    end
  end
end

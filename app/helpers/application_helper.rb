module ApplicationHelper
  def current_subdomain(with_dot=false)
    return request.subdomain + '.' if with_dot unless request.subdomain.empty?
    request.subdomain
  end
end

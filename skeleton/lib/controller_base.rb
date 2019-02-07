require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params, :session
  before_action :prevent_double_render

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    session
  end

  # Helper method to raise error if already_built_response?
  def prevent_double_render
    raise "ALREADY BUILT RESPONSE D00D" if already_built_response?
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url)
    @res.status = 302
    @res['Location'] = url
    @session.store_session(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type='text/html')
    @res.write(content)
    @res['Content-Type'] = content_type
    @already_built_response = true

    @session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.dirname(__FILE__).sub(/(\/lib)/, '')
    snake_class_name = self.class.to_s.underscore
    file_path = File.join(path, 'views', "#{snake_class_name}", "#{template_name}.html.erb")
    content = File.read(file_path)
    erb_code = ERB.new(content).result(binding)
    render_content(erb_code)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end


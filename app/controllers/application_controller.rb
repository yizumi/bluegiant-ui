class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  class Forbidden < ActionController::ActionControllerError; end

  rescue_from WeakParameters::ValidationError do |e|
    logger.error e
    head 400
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    logger.error e
    head 404
  end

  rescue_from Forbidden do |e|
    @exception = e
    render 'errors/forbidden', status: 403
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def forbidden
    raise Forbidden
  end

  def bad_request(e, status = 400)
    render status: status, json: { status: 'error', message: (e.is_a?(String) ? e : e.message) }.to_json
  end

  def after_sign_out_path_for(_resource)
    root_path
  end

  private

  def set_raven_context
    Raven.user_context(session_id: request.cookies['raksul'])
    Raven.extra_context(params: params.to_h, url: request.url)
  end
end

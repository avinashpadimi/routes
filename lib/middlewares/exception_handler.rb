# frozen_string_literal: true

class ExceptionHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue => e
    internal_server_error(e)
  end

  private

  def internal_server_error(exception)
    error = {
      errors: [{
        code: 500,
        detail: 'internal server error',
        message: exception.message.to_s
      }]
    }.to_json
    [500, { 'Content-Type' => 'application/json;charset=utf-8' }, [error]]
  end
end

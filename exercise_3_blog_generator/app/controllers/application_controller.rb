class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern # Rails 8 only

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes # Rails 8 only
end

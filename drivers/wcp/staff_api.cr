module Place; end

require "json"
require "oauth2"
require "placeos"

class Wcp::StaffAPI < PlaceOS::Driver
  def on_load
    logger.debug { "Do nothing" }
  end

  def on_update
    logger.debug { "Do nothing" }
  end
end
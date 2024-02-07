require 'json'
require "logger"


def lambda_handler(event:, context:)
    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG

    action = event['action']
    number = event['number']
    response = ''

    if action == 'increment'
        response = number + 1
    elsif action == 'square'
        response == number * number
    else
        logger.debug("Can only square or increment")
    end

    { statusCode: 200, body: JSON.generate(response) }
end

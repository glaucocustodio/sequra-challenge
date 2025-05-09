class Disbursement
  class Job < ApplicationJob
    queue_as :default

    def perform
      processor = Processor.new
      processor.process
    end
  end
end

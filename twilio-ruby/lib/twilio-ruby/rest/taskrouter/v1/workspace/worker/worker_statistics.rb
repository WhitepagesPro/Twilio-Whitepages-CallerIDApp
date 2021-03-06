##
# This code was generated by
# \ / _    _  _|   _  _
#  | (_)\/(_)(_|\/| |(/_  v1.0.0
#       /       /       

module Twilio
  module REST
    class Taskrouter < Domain
      class V1 < Version
        class WorkspaceContext < InstanceContext
          class WorkerContext < InstanceContext
            class WorkerStatisticsList < ListResource
              ##
              # Initialize the WorkerStatisticsList
              # @param [Version] version Version that contains the resource
              # @param [String] workspace_sid The workspace_sid
              # @param [String] worker_sid The worker_sid
              
              # @return [WorkerStatisticsList] WorkerStatisticsList
              def initialize(version, workspace_sid: nil, worker_sid: nil)
                super(version)
                
                # Path Solution
                @solution = {
                    workspace_sid: workspace_sid,
                    worker_sid: worker_sid
                }
              end
              
              ##
              # Provide a user friendly representation
              def to_s
                '#<Twilio.Taskrouter.V1.WorkerStatisticsList>'
              end
            end
          
            class WorkerStatisticsPage < Page
              ##
              # Initialize the WorkerStatisticsPage
              # @param [Version] version Version that contains the resource
              # @param [Response] response Response from the API
              # @param [Hash] solution Path solution for the resource
              # @param [String] workspace_sid The workspace_sid
              # @param [String] worker_sid The worker_sid
              
              # @return [WorkerStatisticsPage] WorkerStatisticsPage
              def initialize(version, response, solution)
                super(version, response)
                
                # Path Solution
                @solution = solution
              end
              
              ##
              # Build an instance of WorkerStatisticsInstance
              # @param [Hash] payload Payload response from the API
              
              # @return [WorkerStatisticsInstance] WorkerStatisticsInstance
              def get_instance(payload)
                return WorkerStatisticsInstance.new(
                    @version,
                    payload,
                    workspace_sid: @solution['workspace_sid'],
                    worker_sid: @solution['worker_sid'],
                )
              end
              
              ##
              # Provide a user friendly representation
              def to_s
                '<Twilio.Taskrouter.V1.WorkerStatisticsPage>'
              end
            end
          
            class WorkerStatisticsContext < InstanceContext
              ##
              # Initialize the WorkerStatisticsContext
              # @param [Version] version Version that contains the resource
              # @param [String] workspace_sid The workspace_sid
              # @param [String] worker_sid The worker_sid
              
              # @return [WorkerStatisticsContext] WorkerStatisticsContext
              def initialize(version, workspace_sid, worker_sid)
                super(version)
                
                # Path Solution
                @solution = {
                    workspace_sid: workspace_sid,
                    worker_sid: worker_sid,
                }
                @uri = "/Workspaces/#{@solution[:workspace_sid]}/Workers/#{@solution[:worker_sid]}/Statistics"
              end
              
              ##
              # Fetch a WorkerStatisticsInstance
              # @param [String] minutes The minutes
              # @param [Time] start_date The start_date
              # @param [Time] end_date The end_date
              
              # @return [WorkerStatisticsInstance] Fetched WorkerStatisticsInstance
              def fetch(minutes: nil, start_date: nil, end_date: nil)
                params = {
                    'Minutes' => minutes,
                    'StartDate' => Twilio.serialize_iso8601(start_date),
                    'EndDate' => Twilio.serialize_iso8601(end_date),
                }
                
                payload = @version.fetch(
                    'GET',
                    @uri,
                    params,
                )
                
                return WorkerStatisticsInstance.new(
                    @version,
                    payload,
                    workspace_sid: @solution['workspace_sid'],
                    worker_sid: @solution['worker_sid'],
                )
              end
              
              ##
              # Provide a user friendly representation
              def to_s
                context = @solution.map {|k, v| "#{k}: #{v}"}.join(',')
                "#<Twilio.Taskrouter.V1.WorkerStatisticsContext #{context}>"
              end
            end
          
            class WorkerStatisticsInstance < InstanceResource
              ##
              # Initialize the WorkerStatisticsInstance
              # @param [Version] version Version that contains the resource
              # @param [Hash] payload payload that contains response from Twilio
              # @param [String] workspace_sid The workspace_sid
              # @param [String] worker_sid The worker_sid
              
              # @return [WorkerStatisticsInstance] WorkerStatisticsInstance
              def initialize(version, payload, workspace_sid: nil, worker_sid: nil)
                super(version)
                
                # Marshaled Properties
                @properties = {
                    'account_sid' => payload['account_sid'],
                    'cumulative' => payload['cumulative'],
                    'worker_sid' => payload['worker_sid'],
                    'workspace_sid' => payload['workspace_sid'],
                }
                
                # Context
                @instance_context = nil
                @params = {
                    'workspace_sid' => workspace_sid,
                    'worker_sid' => worker_sid,
                }
              end
              
              ##
              # Generate an instance context for the instance, the context is capable of
              # performing various actions.  All instance actions are proxied to the context
              # @param [Version] version Version that contains the resource
              
              # @return [WorkerStatisticsContext] WorkerStatisticsContext for this WorkerStatisticsInstance
              def context
                unless @instance_context
                  @instance_context = WorkerStatisticsContext.new(
                      @version,
                      @params['workspace_sid'],
                      @params['worker_sid'],
                  )
                end
                @instance_context
              end
              
              def account_sid
                @properties['account_sid']
              end
              
              def cumulative
                @properties['cumulative']
              end
              
              def worker_sid
                @properties['worker_sid']
              end
              
              def workspace_sid
                @properties['workspace_sid']
              end
              
              ##
              # Fetch a WorkerStatisticsInstance
              # @param [String] minutes The minutes
              # @param [Time] start_date The start_date
              # @param [Time] end_date The end_date
              
              # @return [WorkerStatisticsInstance] Fetched WorkerStatisticsInstance
              def fetch(minutes: nil, start_date: nil, end_date: nil)
                @context.fetch(
                    start_date: start_date,
                    end_date: end_date,
                )
              end
              
              ##
              # Provide a user friendly representation
              def to_s
                context = @params.map{|k, v| "#{k}: #{v}"}.join(" ")
                "<Twilio.Taskrouter.V1.WorkerStatisticsInstance #{context}>"
              end
            end
          end
        end
      end
    end
  end
end
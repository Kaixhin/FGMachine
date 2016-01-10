local socket = require 'socket'
local http = require 'socket.http'
local ltn12 = require 'ltn12'
local url = require 'socket.url'
local json = require 'json'

-- Constants
local fglabUrl = 'http://localhost:5080'
local projectId = '5692968099ec55d74392c067'
local bot7HelperUrl = 'http://localhost:5000'

-- Performs a HTTP request
local function httpReq(url, method, obj)
  -- Provide default object
  if obj == nil then
    obj = {}
  end

  local jsonStr = json.encode(obj)
  local source = ltn12.source.string(jsonStr)
  local response = {}
  local sink = ltn12.sink.table(response) -- Save response from server in chunks
  local ok, code, headers = http.request{
    url = url,
    method = method,
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = #jsonStr
    },
    source = source,
    sink = sink
  }
  return json.decode(table.concat(response))
end

-- Variable to store result in
local result = nil

-- Objective function to minimise
local objective = function(params)
  -- Submit an experiment
  local experiment = httpReq(fglabUrl .. '/api/v1/projects/' .. projectId .. '/experiment', 'POST', params)
  -- Register a webhook
  httpReq(fglabUrl .. '/api/v1/webhooks', 'POST', {url = bot7HelperUrl, objects = 'experiments', object_id = experiment._id, event = 'finished'})
  -- Create a TCP socket on localhost
  local webhook = assert(socket.bind('*', url.parse(bot7HelperUrl).port))
  -- Wait for the experiment to complete
  local client = webhook:accept()
  --client:settimeout(60) -- Uncomment to set a timeout on waiting
  local response, err = client:receive()
  if not err then
    -- Send a request for experiment results
    experiment = httpReq(fglabUrl .. '/api/v1/experiments/' .. experiment._id, 'GET')
    result = experiment._scores.y
  end
  -- Close connection and server
  client:close()
  webhook:close()
  -- Return experiment result
  return result
end

--return objective
objective({x1 = 1, x2 = 1, x3 = 1, x4 = 1, x5 = 1, x6 = 1})

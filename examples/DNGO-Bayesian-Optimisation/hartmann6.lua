local json = require 'json'

-- Parse command line arguments
local cmd = torch.CmdLine()
cmd:option('-_id', 'id', 'Experiment ID')
cmd:option('-x1', 0.5, 'x1')
cmd:option('-x2', 0.5, 'x2')
cmd:option('-x3', 0.5, 'x3')
cmd:option('-x4', 0.5, 'x4')
cmd:option('-x5', 0.5, 'x5')
cmd:option('-x6', 0.5, 'x6')
local opt = cmd:parse(arg)

-- Constants
local A = -torch.Tensor{{10.0, 3.00, 17.0, 3.50, 1.70, 8.00},
                        {0.05, 10.0, 17.0, 0.10, 8.00, 14.0},
                        {3.00, 3.50, 1.70, 10.0, 17.0, 8.00},
                        {17.0, 8.00, 0.05, 10.0, 0.10, 14.0}}
local P = -torch.Tensor{{.1312, .1696, .5569, .0124, .8283, .5886},
                        {.2329, .4135, .8307, .3736, .1004, .9991},
                        {.2348, .1451, .3522, .2883, .3047, .6650},
                        {.4047, .8828, .8732, .5743, .1091, .0381}}
local a = -torch.Tensor{{1.0, 1.2, 3.0, 3.2}}

-- Unpack input
local x = torch.Tensor{{opt.x1, opt.x2, opt.x3, opt.x4, opt.x5, opt.x6}}:t()

-- Calculate f(x) = -a * exp(-sum(A o (kron(x, [1 1 1 1]') - P)^2, 2))
local y = torch.mm(a, torch.cmul(A, x:repeatTensor(4, 1):add(P):pow(2)):sum(2):exp())[1][1]

-- Make experiment folder
paths.mkdir(opt._id)
-- Save result
local file = torch.DiskFile(paths.concat(opt._id, 'score.json'), 'w')
file:writeString(json.encode({_scores = {y = y}}))
file:close()

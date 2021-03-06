using Klara

p = BasicContUnvParameter(:p, logtarget=p::Float64 -> -abs2(p), gradlogtarget=p::Float64 -> -2*p)

model = likelihood_model([p], isindexed=false)

sampler = MALA(0.95)

tuner = VanillaMCTuner()

mcrange = BasicMCRange(nsteps=10000, burnin=1000)

v0 = Dict(:p=>3.11)

outopts = Dict(:monitor=>[:value, :logtarget, :gradlogtarget], :diagnostics=>[:accept])

job = BasicMCJob(model, sampler, mcrange, v0, outopts=outopts)

@time run(job)

chain = output(job)

mean(chain)

acceptance(chain)

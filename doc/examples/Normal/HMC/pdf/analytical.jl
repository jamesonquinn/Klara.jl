using Distributions, Klara

distribution = Normal()

p = BasicContUnvParameter(
  :p,
  logtarget=x::Float64 -> logpdf(distribution, x),
  gradlogtarget=x::Float64 -> gradlogpdf(distribution, x)
)

model = likelihood_model([p], isindexed=false)

sampler = HMC(1.25)

tuner = VanillaMCTuner()

mcrange = BasicMCRange(nsteps=10000, burnin=1000)

v0 = Dict(:p=>3.11)

outopts = Dict(:monitor=>[:value, :logtarget, :gradlogtarget], :diagnostics=>[:accept])

job = BasicMCJob(model, sampler, mcrange, v0, outopts=outopts)

@time run(job)

chain = output(job)

mean(chain)

acceptance(chain)

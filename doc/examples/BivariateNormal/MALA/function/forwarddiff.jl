using Klara

# Precision matrix
C = Hyperparameter(:C)

p = BasicContMuvParameter(
  :p,
  logtarget=(p::Vector, v::Vector) -> -dot(p, v[1]*p),
  nkeys=2,
  diffopts=DiffOptions(mode=:forward)
)

model = GenericModel([C, p], isindexed=false)

sampler = MALA(0.3)

tuner = VanillaMCTuner()

mcrange = BasicMCRange(nsteps=10000, burnin=1000)

v0 = Dict(:C=>inv([1. 0.8; 0.8 1.]), :p=>[1.25, 3.11])

outopts = Dict(:monitor=>[:value, :logtarget, :gradlogtarget], :diagnostics=>[:accept])

job = BasicMCJob(model, sampler, mcrange, v0, outopts=outopts)

@time run(job)

chain = output(job)

mean(chain)

acceptance(chain)

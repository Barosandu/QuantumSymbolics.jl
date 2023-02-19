# This file defines the expression of quantum objects (kets, operators, and bras) in various representations.
#
# The main function is `express`, which takes a quantum object and a representation and returns an expression of the object in that representation.
export express, express_nolookup, consistent_representation

import SymbolicUtils: Symbolic

# This is the main function for expressing a quantum object in a representation.
function express(state::Symbolic, repr::AbstractRepresentation, use::AbstractUse)
    md = metadata(state)
    isnothing(md) && return express_from_cache(express_nolookup(state, repr, use))
    if haskey(md.express_cache,(repr,use))
        return express_from_cache(md.express_cache[(repr,use)])
    else
        cache = express_nolookup(state, repr, use)
        md.express_cache[(repr,use)] = cache
        return express_from_cache(cache)
    end
end

express(s::Number, repr::AbstractRepresentation, use::AbstractUse) = s

# Assume two-argument express statements are for "as state" representations.
express(s, repr::AbstractRepresentation) = express(s, repr, UseAsState())

# Default to the two-argument expression unless overwritten
express_nolookup(x, repr::AbstractRepresentation, ::AbstractUse) = express_nolookup(x, repr)

# The two-argument expression is the AsState one
express_nolookup(x, repr::AbstractRepresentation, ::UseAsState) = express_nolookup(x, repr)

# Most of the time the cache is exactly the expression we need,
# but we need indirection to be able to implement cases
# where the cache is a distribution over possible samples.
express_from_cache(cache) = cache

function consistent_representation(regs,idx,state)
    reprs = Set([r.reprs[i] for (r,i) in zip(regs,idx)])
    if length(reprs)>1
        error("no way to choose yet")
    end
    pop!(reprs)
end

##
# Commonly used representations -- interfaces for each one defined in separate packages
##

"""Representation using kets, bras, density matrices, and superoperators governed by `QuantumOptics.jl`."""
struct QuantumOpticsRepr <: AbstractRepresentation end
"""Similar to `QuantumOpticsRepr`, but using trajectories instead of superoperators."""
struct QuantumMCRepr <: AbstractRepresentation end
"""Representation using tableaux governed by `QuantumClifford.jl`"""
struct CliffordRepr <: AbstractRepresentation end

express(state::Symbolic) = express(state, QuantumOpticsRepr()) # The default representation
express_nolookup(state, ::QuantumMCRepr) = express_nolookup(state, QuantumOpticsRepr())
express(state) = state

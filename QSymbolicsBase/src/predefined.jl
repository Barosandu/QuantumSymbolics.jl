##
# Pure States
##

abstract type SpecialKet <: Symbolic{AbstractKet} end
istree(::SpecialKet) = false
basis(x::SpecialKet) = x.basis

@withmetadata struct XBasisState <: SpecialKet
    idx::Int
    basis::Basis
end
Base.show(io::IO, x::XBasisState) = print(io, "|X$(num_to_sub(x.idx))⟩")

@withmetadata struct YBasisState <: SpecialKet
    idx::Int
    basis::Basis
end
Base.show(io::IO, x::YBasisState) = print(io, "|Y$(num_to_sub(x.idx))⟩")

@withmetadata struct ZBasisState <: SpecialKet
    idx::Int
    basis::Basis
end
Base.show(io::IO, x::ZBasisState) = print(io, "|Z$(num_to_sub(x.idx))⟩")

@withmetadata struct FockBasisState <: SpecialKet
    idx::Int
    basis::Basis
end
Base.show(io::IO, x::FockBasisState) = print(io, "|$(x.idx)⟩")

@withmetadata struct DiscreteCoherentState <: SpecialKet
    alpha::Number # TODO parameterize
    basis::Basis
end
Base.show(io::IO, x::DiscreteCoherentState) = print(io, "|$(x.alpha)⟩")

@withmetadata struct ContinuousCoherentState <: SpecialKet
    alpha::Number # TODO parameterize
    basis::Basis
end
Base.show(io::IO, x::ContinuousCoherentState) = print(io, "|$(x.alpha)⟩")

@withmetadata struct MomentumEigenState <: SpecialKet
    p::Number # TODO parameterize
    basis::Basis
end
Base.show(io::IO, x::MomentumEigenState) = print(io, "|δₚ($(x.p))⟩")

@withmetadata struct PositionEigenState <: SpecialKet
    x::Float64 # TODO parameterize
    basis::Basis
end
Base.show(io::IO, x::PositionEigenState) = print(io, "|δₓ($(x.x))⟩")

const qubit_basis = SpinBasis(1//2)
"""Basis state of σˣ"""
const X1 = const X₁ = const Lp = const L₊ = XBasisState(1, qubit_basis)
"""Basis state of σˣ"""
const X2 = const X₂ = const Lm = const L₋ = XBasisState(2, qubit_basis)
"""Basis state of σʸ"""
const Y1 = const Y₁ = const Lpi = const L₊ᵢ = YBasisState(1, qubit_basis)
"""Basis state of σʸ"""
const Y2 = const Y₂ = const Lmi = const L₋ᵢ = YBasisState(2, qubit_basis)
"""Basis state of σᶻ"""
const Z1 = const Z₁ = const L0 = const L₀ = ZBasisState(1, qubit_basis)
"""Basis state of σᶻ"""
const Z2 = const Z₂ = const L1 = const L₁ = ZBasisState(2, qubit_basis)

const inf_fock_basis = FockBasis(Inf,0.)
"""Vacuum basis state of n"""
const vac = const F₀ = const F0 = FockBasisState(0,inf_fock_basis)
"""Single photon basis state of n"""
const F₁ = const F1 = FockBasisState(1,inf_fock_basis)


##
# Gates and Operators on qubits
##

abstract type AbstractSingleQubitOp <: Symbolic{AbstractOperator} end
abstract type AbstractTwoQubitOp <: Symbolic{AbstractOperator} end
abstract type AbstractSingleQubitGate <: AbstractSingleQubitOp end # TODO maybe an IsUnitaryTrait is a better choice
abstract type AbstractTwoQubitGate <: AbstractTwoQubitOp end
istree(::AbstractSingleQubitGate) = false
istree(::AbstractTwoQubitGate) = false
basis(::AbstractSingleQubitGate) = qubit_basis
basis(::AbstractTwoQubitGate) = qubit_basis⊗qubit_basis

@withmetadata struct OperatorEmbedding <: Symbolic{AbstractOperator}
    gate::Symbolic{AbstractOperator} # TODO parameterize
    indices::Vector{Int}
    basis::Basis
end
istree(::OperatorEmbedding) = true

@withmetadata struct XGate <: AbstractSingleQubitGate end
eigvecs(g::XGate) = [X1,X2]
Base.show(io::IO, ::XGate) = print(io, "X̂")
@withmetadata struct YGate <: AbstractSingleQubitGate end
eigvecs(g::YGate) = [Y1,Y2]
Base.show(io::IO, ::YGate) = print(io, "Ŷ")
@withmetadata struct ZGate <: AbstractSingleQubitGate end
eigvecs(g::ZGate) = [Z1,Z2]
Base.show(io::IO, ::ZGate) = print(io, "Ẑ")
@withmetadata struct PauliM <: AbstractSingleQubitGate end
Base.show(io::IO, ::PauliM) = print(io, "σ̂₋")
@withmetadata struct PauliP <: AbstractSingleQubitGate end
Base.show(io::IO, ::PauliP) = print(io, "σ̂₊")
@withmetadata struct HGate <: AbstractSingleQubitGate end
Base.show(io::IO, ::HGate) = print(io, "Ĥ")
@withmetadata struct CNOTGate <: AbstractTwoQubitGate end
Base.show(io::IO, ::CNOTGate) = print(io, "ĈNOT")
@withmetadata struct CPHASEGate <: AbstractTwoQubitGate end
Base.show(io::IO, ::CPHASEGate) = print(io, "ĈPHASE")

"""Pauli X operator, also available as the constant `σˣ`"""
const X = const σˣ = XGate()
"""Pauli Y operator, also available as the constant `σʸ`"""
const Y = const σʸ = YGate()
"""Pauli Z operator, also available as the constant `σᶻ`"""
const Z = const σᶻ = ZGate()
"""Pauli "minus" operator, also available as the constant `σ₋`"""
const Pm = const σ₋ = PauliM()
"""Pauli "plus" operator, also available as the constant `σ₊`"""
const Pp = const σ₊ = PauliP()
"""Hadamard gate"""
const H = HGate()
"""CNOT gate"""
const CNOT = CNOTGate()
"""CPHASE gate"""
const CPHASE = CPHASEGate()

##
# Gates and Operators on harmonic oscillators
##

abstract type AbstractSingleBosonOp <: Symbolic{AbstractOperator} end
abstract type AbstractSingleBosonGate <: AbstractSingleBosonOp end # TODO maybe an IsUnitaryTrait is a better choice
istree(::AbstractSingleBosonGate) = false
basis(::AbstractSingleBosonGate) = inf_fock_basis

@withmetadata struct NumberOp <: AbstractSingleBosonOp end
Base.show(io::IO, ::NumberOp) = print(io, "n̂")
@withmetadata struct CreateOp <: AbstractSingleBosonOp end
Base.show(io::IO, ::CreateOp) = print(io, "â†")
@withmetadata struct DestroyOp <: AbstractSingleBosonOp end
Base.show(io::IO, ::DestroyOp) = print(io, "â")

"""Number operator, also available as the constant `n̂`"""
const N = const n̂ = NumberOp()
"""Creation operator, also available as the constant `âꜛ` - there is no unicode dagger superscript, so we use the uparrow"""
const Create = const âꜛ = CreateOp()
"""Annihilation operator, also available as the constant `â`"""
const Destroy = const â = DestroyOp()

##
# Other special or useful objects
##

"""Projector for a given ket

```jldoctest
julia> SProjector(X1⊗X2)
𝐏[|X₁⟩|X₂⟩]

julia> express(SProjector(X2))
Operator(dim=2x2)
  basis: Spin(1/2)
  0.5+0.0im  -0.5-0.0im
 -0.5+0.0im   0.5+0.0im
```"""
@withmetadata struct SProjector <: Symbolic{AbstractOperator}
    ket::Symbolic{AbstractKet} # TODO parameterize
end
istree(::SProjector) = true
arguments(x::SProjector) = [x.ket]
operation(x::SProjector) = projector
projector(x::Symbolic{AbstractKet}) = SProjector(x)
basis(x::SProjector) = basis(x.ket)
function Base.show(io::IO, x::SProjector)
    print(io,"𝐏[")
    print(io,x.ket)
    print(io,"]")
end

"""Dagger a Ket into Bra."""
@withmetadata struct SDagger <: Symbolic{AbstractBra}
    ket::Symbolic{AbstractKet}
end
istree(::SDagger) = true
arguments(x::SDagger) = [x.ket]
operation(x::SDagger) = dagger
dagger(x::Symbolic{AbstractKet}) = SDagger(x)
basis(x::SDagger) = basis(x.ket)
function Base.show(io::IO, x::SDagger)
    print(io,x.ket)
    print(io,"†")
end

"""Completely depolarized state

```jldoctest
julia> MixedState(X1⊗X2)
𝕄

julia> express(MixedState(X1⊗X2))
Operator(dim=4x4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]sparse([1, 2, 3, 4], [1, 2, 3, 4], ComplexF64[0.25 + 0.0im, 0.25 + 0.0im, 0.25 + 0.0im, 0.25 + 0.0im], 4, 4)

  express(MixedState(X1⊗X2), CliffordRepr())
  Rank 0 stabilizer

  ━━━━
  + X_
  + _X
  ━━━━

  ━━━━
  + Z_
  + _Z
```"""
@withmetadata struct MixedState <: Symbolic{AbstractOperator}
    basis::Basis # From QuantumOpticsBase # TODO make QuantumInterface
end
MixedState(x::Symbolic{AbstractKet}) = MixedState(basis(x))
MixedState(x::Symbolic{AbstractOperator}) = MixedState(basis(x))
istree(::MixedState) = false
basis(x::MixedState) = x.basis
Base.show(io::IO, x::MixedState) = print(io, "𝕄")

"""The identity operator for a given basis

```judoctest
julia> IdentityOp(X1⊗X2)
𝕀

julia> express(IdentityOp(Z2))
Operator(dim=2x2)
  basis: Spin(1/2)sparse([1, 2], [1, 2], ComplexF64[1.0 + 0.0im, 1.0 + 0.0im], 2, 2)
```"""
@withmetadata struct IdentityOp <: Symbolic{AbstractOperator}
    basis::Basis # From QuantumOpticsBase # TODO make QuantumInterface
end
IdentityOp(x::Symbolic{AbstractKet}) = IdentityOp(basis(x))
IdentityOp(x::Symbolic{AbstractOperator}) = IdentityOp(basis(x))
istree(::IdentityOp) = false
basis(x::IdentityOp) = x.basis
Base.show(io::IO, x::IdentityOp) = print(io, "𝕀")

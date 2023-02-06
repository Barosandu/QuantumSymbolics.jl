@withmetadata struct SApplyKet <: Symbolic{AbstractKet}
    op
    ket
end
istree(::SApplyKet) = true
arguments(x::SApplyKet) = [x.op,x.ket]
operation(x::SApplyKet) = *
Base.:(*)(op::Symbolic{AbstractOperator}, k::Symbolic{AbstractKet}) = SApplyKet(op,k)
Base.show(io::IO, x::SApplyKet) = begin print(io, x.op); print(io, x.ket) end
basis(x::SApplyKet) = basis(x.ket)

@withmetadata struct SBraKet <: Symbolic{Complex}
    bra
    op
    ket
end
istree(::SBraKet) = true
arguments(x::SBraKet) = [x.bra,x.op,x.ket]
operation(x::SBraKet) = *
#Base.:(*)(b::Symbolic{Bra}, op::Symbolic{Operator}, k::Symbolic{Ket}) = SBraKet(b,op,k)
function Base.show(io::IO, x::SBraKet)
    if isnothing(x.op)
        print(io,string(x.bra)[1:end-1])
        print(io,x.ket)
    else
        print(io.x.bra)
        print(io.x.op)
        print(io.x.ket)
    end
end

@withmetadata struct SApplyOp <: Symbolic{AbstractOperator}
    sop
    op
end
istree(::SApplyOp) = true
arguments(x::SApplyOp) = [x.sop,x.op]
operation(x::SApplyOp) = *
Base.:(*)(sop::Symbolic{AbstractSuperOperator}, op::Symbolic{AbstractOperator}) = SApplyOp(sop,op)
Base.:(*)(sop::Symbolic{AbstractSuperOperator}, k::Symbolic{AbstractKet}) = SApplyOp(sop,SProjector(k))
Base.show(io::IO, x::SApplyOp) = begin print(io, x.sop); print(io, x.op) end
basis(x::SApplyOp) = basis(x.op)

using MappedArrays, FixedPointNumbers
using Base.Test

a = [1,4,9,16]
s = view(a', 1:1, [1,2,4])

b = mappedarray(sqrt, a)
@test parent(b) === a
@test eltype(b) == Float64
@test @inferred(getindex(b, 1)) == 1
@test b[2] == 2
@test b[3] == 3
@test b[4] == 4
@test_throws ErrorException b[3] = 0
@test isa(eachindex(b), AbstractUnitRange)
b = mappedarray(sqrt, a')
@test isa(eachindex(b), AbstractUnitRange)
b = mappedarray(sqrt, s)
@test isa(eachindex(b), CartesianRange)

c = mappedarray((sqrt, x->x*x), a)
@test parent(c) === a
@test @inferred(getindex(c, 1)) == 1
@test c[2] == 2
@test c[3] == 3
@test c[4] == 4
c[3] = 2
@test a[3] == 4
@test_throws InexactError c[3] = 2.2  # because the backing array is Array{Int}
@test isa(eachindex(c), AbstractUnitRange)
b = mappedarray(sqrt, a')
@test isa(eachindex(b), AbstractUnitRange)
c = mappedarray((sqrt, x->x*x), s)
@test isa(eachindex(c), CartesianRange)

sb = similar(b)
@test isa(sb, Array{Float64})
@test size(sb) == size(b)

a = [0x01 0x03; 0x02 0x04]
b = mappedarray((y->UFixed8(y,0),x->x.i), a)
for i = 1:4
    @test b[i] == UFixed8(i/255)
end
b[2,1] = 10/255
@test a[2,1] == 0x0a

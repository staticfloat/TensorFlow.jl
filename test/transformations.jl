using TensorFlow
using Base.Test

sess = TensorFlow.Session(TensorFlow.Graph())

@test [1, 2] == run(sess, cast(constant([1.8, 2.2]), Int))

one_tens = ones(Tensor, (5,5))

@test ones(25) == run(sess, reshape(one_tens, 25))

@test ones(Float32, 5).' == run(sess, slice(one_tens, [0, 0], [1, -1]))

@test Int32[5,5,1] == run(sess, TensorFlow.shape(pack(split(2, 5, one_tens), axis=1)))

@test ones(Float32, 5,5) == run(sess, pack(unpack(one_tens, num=5)))

@test ones(5,5,1) == run(sess, expand_dims(one_tens, 2))

@test 2 == run(sess, rank(one_tens))

@test ones(10,5) == run(sess, tile(one_tens, [2; 1]))

@test ones(Float32, 4,3) == run(sess, transpose(ones(Tensor, (3, 4))))
@test ones(Float32, 4,3,2) == run(sess, permutedims(ones(Tensor, (4, 2, 3)), [1, 3, 2]))

@test hcat(ones(Float32, 5,5), zeros(Float32, 5)) == run(sess, pad(one_tens, [0 0; 0 1]))

# to do make sure we slice the right indices
@test ones(Float32, 2, 5) == run(sess, gather(one_tens, [1, 2]))

@test Float32[1.; 0.; 0.; 0.; 0.] == run(sess, one_hot(1, 5))

a = Tensor(collect(1:5))
result = run(sess, shuffle(a))
for i in 1:5
    @test i ∈ result
end

@testset "CheckNumElementsUnderRank" begin
    src = Shape([2, 3, 5, 7, 11, 13])
    @test 1 == lower_volume(src, 0)
    @test 2 == lower_volume(src, 1)
    @test 2 * 3 == lower_volume(src, 2)
    @test 2 * 3 * 5 == lower_volume(src, 3)
    @test 2 * 3 * 5 * 7 == lower_volume(src, 4)
    @test 2 * 3 * 5 * 7 * 11 == lower_volume(src, 5)
    @test 2 * 3 * 5 * 7 * 11 * 13 == lower_volume(src, 6)
end

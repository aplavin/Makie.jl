using GLMakie

function set_xkcd_text_theme!()
    font_path = joinpath(@__DIR__, "fonts", "xkcd-script.ttf")
    isfile(font_path) || error("Missing xkcd font at: $font_path")

    set_theme!(
        font = font_path,
        fontsize = 18,
        Figure = (
            fontsize = 18,
        ),
        Axis = (
            titlefont = font_path,
            xlabelfont = font_path,
            ylabelfont = font_path,
            xticklabelfont = font_path,
            yticklabelfont = font_path,
            titlesize = 26,
            xlabelsize = 22,
            ylabelsize = 22,
            xticklabelsize = 18,
            yticklabelsize = 18,
        ),
        Legend = (
            labelfont = font_path,
            labelsize = 18,
        ),
    )
    return font_path
end

function densify_polyline(points::AbstractVector{Point2f}, samples_per_segment::Integer)
    length(points) >= 2 || return Point2f[]
    segments = map(zip(points[1:end-1], points[2:end])) do (p1, p2)
        t = range(0, 1; length = samples_per_segment + 1)
        Point2f.((1 .- t) .* p1[1] .+ t .* p2[1], (1 .- t) .* p1[2] .+ t .* p2[2])
    end
    pieces = vcat(map(s -> s[1:end-1], segments[1:end-1]), [segments[end]])
    return reduce(vcat, pieces)
end

function add_demo_lines!(ax)
    xs = range(0, 10; length = 400)

    # Straight 2-point lines
    foreach(0:4) do i
        y = -5.0 + 0.7i
        lines!(ax, [0.0, 10.0], [y, y]; color = (:black, 0.65), linewidth = 2)
    end

    # Sparse and dense samples of the same zig-zag geometry (density invariance)
    sparse_base = Point2f[
        (0.0, -1.0), (2.0, 1.5), (4.0, -0.8),
        (6.0, 2.2), (8.0, -1.2), (10.0, 1.1)
    ]
    dense_base = densify_polyline(sparse_base, 45)
    sparse_zig = map(p -> p + Point2f(0, 0.0), sparse_base)
    dense_zig = map(p -> p + Point2f(0, 3.0), dense_base)
    lines!(ax, sparse_zig; color = (:royalblue3, 0.95), linewidth = 3, joinstyle = :round, label = "sparse zig-zag")
    lines!(ax, dense_zig; color = (:orange3, 0.95), linewidth = 3, joinstyle = :round, label = "dense zig-zag")

    # Curved lines
    t = range(0, 2pi; length = 320)
    lines!(ax, 5 .+ 3cos.(t), 1.8 .+ 1.2sin.(t); color = :tomato3, linewidth = 3)

    y = 2.8 .+ 0.9sin.(1.4 .* xs) .+ 0.25sin.(4.2 .* xs)
    lines!(ax, xs, y; color = :seagreen4, linewidth = 3, linestyle = :dash)

    # Straight-ish connected line segments
    anchors = Point2f[
        (0.0, 4.8), (2.0, 5.8), (2.5, 4.9), (4.0, 5.7),
        (5.3, 4.7), (7.2, 5.9), (8.5, 4.9), (10.0, 5.6)
    ]
    segment_pairs = reduce(vcat, map(((p, q),) -> Point2f[p, q], zip(anchors[1:end-1], anchors[2:end])))
    linesegments!(ax, segment_pairs; color = :purple4, linewidth = 2.5)

    limits!(ax, 0, 10, -6, 7)
    return ax
end

function make_figure()
    fig = Figure(size = (500, 350), backgroundcolor = :white)

    ax = Axis(
        fig[1, 1],
        title = "Global GLMakie Wobble (all lines, spines, grid)",
        xlabel = "x",
        ylabel = "y",
        xgridvisible = true,
        ygridvisible = true,
    )

    add_demo_lines!(ax)
    axislegend(ax; position = :lt, framevisible = false)

    fig
end

GLMakie.activate!()
GLMakie.GLOBAL_LINE_WOBBLE.strength = 1.2f0
GLMakie.GLOBAL_LINE_WOBBLE.amplitude_px = 1.6f0
GLMakie.GLOBAL_LINE_WOBBLE.freq_1 = 0.07f0
GLMakie.GLOBAL_LINE_WOBBLE.freq_2 = 0.16f0
GLMakie.GLOBAL_LINE_WOBBLE.length_px = 100.0f0
GLMakie.GLOBAL_LINE_WOBBLE.randomness = 2.0f0

font_path = set_xkcd_text_theme!()
fig = make_figure()
output_path = joinpath(@__DIR__, "wobble_lines_demo.png")
save(output_path, fig)
println("Font: ", font_path)
println("Saved: ", output_path)

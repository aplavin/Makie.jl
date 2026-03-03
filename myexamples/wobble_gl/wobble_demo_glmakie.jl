using GLMakie
using Random

function make_wobble_figure()
    Random.seed!(20260303)

    wobble_theme = Theme(
        fontsize = 16,
        figure_padding = 22,
        backgroundcolor = RGBf(0.985, 0.975, 0.94),
        palette = (color = [:black, :dodgerblue3, :tomato3, :seagreen4, :darkorange3],),
        Lines = (
            linewidth = 2.6,
            linecap = :round,
            joinstyle = :round,
            wobble = 0.018,
            wobble_seed = 777,
        ),
        LineSegments = (
            linewidth = 1.7,
            linecap = :round,
            wobble = 0.018,
            wobble_seed = 777,
        ),
        Axis = (
            backgroundcolor = RGBf(0.99, 0.985, 0.965),
            xgridvisible = true,
            ygridvisible = true,
            xminorgridvisible = true,
            yminorgridvisible = true,
            xminorticksvisible = true,
            yminorticksvisible = true,
            xgridcolor = RGBAf(0.0, 0.0, 0.0, 0.18),
            ygridcolor = RGBAf(0.0, 0.0, 0.0, 0.18),
            xminorgridcolor = RGBAf(0.0, 0.0, 0.0, 0.09),
            yminorgridcolor = RGBAf(0.0, 0.0, 0.0, 0.09),
            spinewidth = 1.9,
            xtickwidth = 1.9,
            ytickwidth = 1.9,
            xgridwidth = 1.25,
            ygridwidth = 1.25,
            titlefont = :bold,
        ),
    )

    with_theme(wobble_theme) do
        fig = Figure(size = (1280, 820))

        Label(
            fig[0, :],
            "GLMakie Wobble Demo: Axis + Grid + Plot Lines",
            font = :bold,
            fontsize = 26,
            color = :black,
        )

        x = LinRange(0, 12, 600)

        ax1 = Axis(
            fig[1, 1],
            title = "Layered Signals (Global Wobble Theme)",
            xlabel = "t",
            ylabel = "signal",
        )
        lines!(ax1, x, 0.75 .* sin.(x) .+ 0.15 .* sin.(5x), color = Cycled(1), label = "channel A")
        lines!(ax1, x, 0.65 .* cos.(x .+ 0.35) .+ 0.22, color = Cycled(2), label = "channel B")
        lines!(ax1, x, 0.45 .* sin.(1.8x .+ 0.7) .- 0.4, color = Cycled(3), label = "channel C")
        axislegend(ax1, position = :rb, framevisible = false)

        ax2 = Axis(
            fig[1, 2],
            title = "Same Data, Different wobble_seed",
            xlabel = "x",
            ylabel = "y",
        )
        y = sin.(x) .+ 0.09 .* sin.(8x)
        lines!(ax2, x, y, color = Cycled(1), wobble_seed = 10, label = "seed = 10")
        lines!(ax2, x, y .- 1.1, color = Cycled(4), wobble_seed = 999, label = "seed = 999")
        axislegend(ax2, position = :rb, framevisible = false)

        ax3 = Axis(
            fig[2, 1:2],
            title = "Stress Test: Many Curves + Dense Grid",
            xlabel = "time",
            ylabel = "offset curve",
        )
        for (i, phase) in enumerate(LinRange(0, 2pi, 10))
            y = 0.28 .* sin.(x .* (0.85 + 0.04i) .+ phase) .+ 0.19i
            lines!(ax3, x, y, color = Cycled(mod1(i, 5)), wobble_seed = 100 + i)
        end
        xlims!(ax3, 0, 12)

        return fig
    end
end

function main()
    GLMakie.activate!()
    fig = make_wobble_figure()
    display(fig)
    outpath = joinpath(@__DIR__, "wobble_demo_glmakie.png")
    save(outpath, fig)
    println("Saved preview image to: ", outpath)
    return fig
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

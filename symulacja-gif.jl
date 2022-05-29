using CSV
using DataFrames
using Plots
using CircularArrays


function Ising_2(L, T, MCS, random=false)

    kB = 1.380649 * 10^(-23)
    N = L^2
    m = []

    if random
        table = CircularArray(rand([-1, 1], L, L))
    else
        table = CircularArray(fill(1, L, L))
    end

    anim = @animate for step in 1:MCS
        for spin in 1:N
            x = rand(1:L)
            y = rand(1:L)
            ΔE = 2 * table[x, y] * (table[x-1, y] + table[x+1, y] + table[x, y-1] + table[x, y+1]) 
            if ΔE <= 0
                table[x, y] *= -1
            else
                if rand() < exp(-ΔE/T)
                    table[x, y] *= -1
                end
            end
        end
        append!(m, sum(table) / N)

        heatmap(table,
            aspectratio=1,
            size=(600, 600),
            title="T = $T,   MCS = $step",
            grid=false,
            axis=false,
            ticks=false,
            legend=false,
            color=:blues)
    end
    gif(anim, "Ising.gif", fps=30) |> display
    return m
end


m = Ising_2(10, 1, 30, true)
#plot(data.m, dpi=500)

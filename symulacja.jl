using CSV
using DataFrames
using Plots
using CircularArrays


function Ising_1(L, T, MCS)

    kB = 1.380649 * 10^(-23)
    N = L^2
    table = CircularArray(rand([-1, 1], L, L))
    m = []

    for step in 1:MCS
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
    end
    return m
end


m = Ising_1(100, 1, 10000)
data = DataFrame(m = m)
CSV.write("data.csv", data)
data = CSV.read("data.csv", DataFrame)
plot(data.m, dpi=500)

### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 7b93882c-9ad8-11ea-0288-0941e163f9d5
md"""
# Convex Hull of 2D points

Convex means that the polygon has no corner that is bent inwards.
If you were to wrap a rope around people in a crowd, the convex hull will be the shape formed by the rope. 


Let's start by importing the `Plots` package. We do this in a special way, which guarantees that anyone who opens the notebook can use the package.
"""

# ╔═╡ 8d415e40-7535-11eb-1c7d-a3431bc39e68
md"""
The simplest example of a convex set are empty set, a single point and the entire space . Another simple example is a line:

```math
y = a x_1 + (1-a)x_2 
```

A set \$K ⊆ R^d\$ is convex if given any points \$p, q ∈ K\$, the line segment \$pq\$
is entirely contained within K. This is true due to the convexity, given any two points we can generate a point on the line as a linear combination of their cordinates. 

"""

# ╔═╡ fdd962c0-7539-11eb-021a-bb3320033551


# ╔═╡ d889e13e-f0ff-11ea-3306-57491904d83f
md"_First, we set up a clean package environment:_"

# ╔═╡ aefb6004-f0ff-11ea-10c9-c504c7aa9fe5
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ a0f0ae42-9ad8-11ea-2475-a735df64aa28
begin
	Pkg.add("Plots")
	Pkg.add("LaTeXStrings")
	using Plots
	using LaTeXStrings
end

# ╔═╡ e48a0e78-f0ff-11ea-2852-2f4eee1a7d2d
md"_Next, we add the `Plots` package to our environment, and we import it._"

# ╔═╡ a9a3c640-f100-11ea-2e86-5f0e81a37ebd
md"You can just put a cell like this anywhere in your notebook, if you want to add+import more packages."

# ╔═╡ c042d3d2-f100-11ea-3833-af1f19afd400
md"(If you already had Plots installed, then this will just use the globally installed version! Neat)"

# ╔═╡ e5abaf40-f105-11ea-1494-2da858d7db5b
md"We need to choose a _backend_ for Plots.jl. We choose `plotly` because it works with no additional dependencies. You can [read more about backends](http://docs.juliaplots.org/latest/backends/#backends) in Plots.jl - it's one of its coolest features!"

# ╔═╡ 9414a092-f105-11ea-10cd-23f84e47d876
plotly()

# ╔═╡ 5ae65950-9ad9-11ea-2e14-35119d369acd
md"""
## The Jarvis Algorithms
Now we can get started. We can begin by making some X and Y values. I typed out some Y values so you can alter them and see the effect. 
"""

# ╔═╡ aaa805d4-9ad8-11ea-21c2-3b20580fea0e
years = 2002:2011

# ╔═╡ c02bc44a-9ad8-11ea-117d-3997e1f3cab0
apples = [15, 25, 80, 75, 50, 30, 35, 15, 25, 35]

# ╔═╡ a405ae4c-9ad9-11ea-0008-f763e098846d
md"""
Great, let's plot them! The basic syntax of of `Plots` is very simple.
"""

# ╔═╡ 12a8c222-9ad9-11ea-2544-355bd080367f
plot(years, apples)

# ╔═╡ eb218bea-9adc-11ea-2f3a-298c41caf8a1
md"""
## More options

We can easily plot multiple series.
"""

# ╔═╡ bd30bdf4-9add-11ea-26d4-75ac3f0b8610
begin
	domain = rand(1:100, 10)
	range = rand(1:100, 10)
end

# ╔═╡ dc50d480-9add-11ea-2821-018a98fab262
begin
	plot(years, domain, label="apples")
	plot!(years, range, label="oranges")
end

# ╔═╡ c9a64e98-9b67-11ea-1d6a-3b1f7548cb8d
md"""
Different plot types have their own functions.
"""

# ╔═╡ 13428812-9ade-11ea-3865-1d293993203d
scatter(domain, range, legend=false)

# ╔═╡ a2295280-752c-11eb-2286-efa9e01d9eb0
plot(domain, range)

# ╔═╡ d76fd0f6-9b67-11ea-0a73-e9ddb60ca291
md"""
You can also plot a function instead of an output array!
"""

# ╔═╡ 69fa7744-9b67-11ea-26df-3b4446dfb3ea
plot(domain,range,seriestype=:shape, fill=:blue, opacity=0.3, linecolour="blue", line=3, legend=false)

# ╔═╡ af31a428-9adf-11ea-280a-45e2b891c4f9
md"""
## Naming plots

Plots are also just a type of variable, so you can give them a name.
"""

# ╔═╡ 5ed7c444-9adf-11ea-2925-8573f018e820
apples_plot = plot(years, apples, 
	legend=false, xlabel="year", ylabel="apples")

# ╔═╡ 932b6b3c-a64d-11ea-2aba-2bf577ce3cf8
apples_vs_oranges = scatter(apples, oranges, 
	legend=false, xlabel="apples", ylabel="oranges")

# ╔═╡ 030c1d10-9b69-11ea-11b7-ff04c60892b9
md"""
This way, you can show them again
"""

# ╔═╡ d7bdab72-9b65-11ea-18c0-5353a214749d
apples_plot

# ╔═╡ 22992cec-9adb-11ea-078e-c7c21489c053
md"""
## Combining subplots

We can combine multiple plots in a single image using the `layout` argument. One option is to provide a matrix of values and call a single `plot`.
"""

# ╔═╡ 5d723220-9ade-11ea-37db-c110dda60a15
pears = rand(1:100, 10)

# ╔═╡ 632cb26c-9ade-11ea-1bc7-39b8207190e2
bananas = rand(1:100, 10)

# ╔═╡ a01bf430-9ade-11ea-2ae4-23287ba11406
fruits = hcat(apples, oranges, pears, bananas)

# ╔═╡ 69e045b0-9ade-11ea-0c55-05fa0da5893c
plot(years, fruits, layout=(4, 1), legend=false)

# ╔═╡ 054e0c4e-9adf-11ea-3deb-4daf2b6a2548
md"""
This works when we have a nice output matrix. For more complicated options, named plots are usually a good solution. When we have created a few plots, we can put them together in a single plot.
"""

# ╔═╡ 91b4eedc-9adf-11ea-37aa-250ceec26640
plot(apples_plot, apples_vs_oranges, layout=(1, 2))

# ╔═╡ a7abf64e-9adb-11ea-2ae4-47886125fe60
md"""
## The Pluto way of plotting

For the most part, plotting in Pluto is not different from anywhere else. However, there are a few things to keep in mind.

The `plot!()` function alters an existing plot. In reactive programming, you are not supposed to alter the value of a variable you defined in a different cell. I strongly recommend that you only use `plot!()` to alter plots you initialised in the same cell. 

For the sake of demonstration, here is what happens if you use `plot!()` in its own cell. Let's start by making a new plot.
"""

# ╔═╡ 46388876-9ae2-11ea-2c5f-073698e45d44
md"""
The cell below adds a new series to the plot. It shows the altered plot, while our original plot still looks intact.

Maybe that's not so bad. It seems like we could use this to build a plot one step at a time. But try changing the plot below so that it plots oranges instead of bananas.
"""

# ╔═╡ a9cdba00-9ae2-11ea-3bf9-41d07e7a785f
md"""
Did you get three series? It's because the `plot` still has the `bananas` data added to it. So the bananas are still plotted, even though you now don't have any code doing that. This is not great for coding: it means that if you close your notebook, your plots might not look the same when you open it again.

Try running the cell a few times. You keep adding series! Also not great when working on a plot.
"""

# ╔═╡ f22b6fda-9ae3-11ea-3ff2-ebcf1374f595
md"""
So what if you do want to add things to a plot one at a time, instead of using a single cell? My recommendation is to define your plot in a function.
"""

# ╔═╡ Cell order:
# ╟─7b93882c-9ad8-11ea-0288-0941e163f9d5
# ╟─8d415e40-7535-11eb-1c7d-a3431bc39e68
# ╠═fdd962c0-7539-11eb-021a-bb3320033551
# ╠═d889e13e-f0ff-11ea-3306-57491904d83f
# ╠═aefb6004-f0ff-11ea-10c9-c504c7aa9fe5
# ╟─e48a0e78-f0ff-11ea-2852-2f4eee1a7d2d
# ╠═a0f0ae42-9ad8-11ea-2475-a735df64aa28
# ╟─a9a3c640-f100-11ea-2e86-5f0e81a37ebd
# ╟─c042d3d2-f100-11ea-3833-af1f19afd400
# ╟─e5abaf40-f105-11ea-1494-2da858d7db5b
# ╠═9414a092-f105-11ea-10cd-23f84e47d876
# ╠═5ae65950-9ad9-11ea-2e14-35119d369acd
# ╠═aaa805d4-9ad8-11ea-21c2-3b20580fea0e
# ╠═c02bc44a-9ad8-11ea-117d-3997e1f3cab0
# ╟─a405ae4c-9ad9-11ea-0008-f763e098846d
# ╠═12a8c222-9ad9-11ea-2544-355bd080367f
# ╟─eb218bea-9adc-11ea-2f3a-298c41caf8a1
# ╠═bd30bdf4-9add-11ea-26d4-75ac3f0b8610
# ╠═dc50d480-9add-11ea-2821-018a98fab262
# ╟─c9a64e98-9b67-11ea-1d6a-3b1f7548cb8d
# ╠═13428812-9ade-11ea-3865-1d293993203d
# ╠═a2295280-752c-11eb-2286-efa9e01d9eb0
# ╠═d76fd0f6-9b67-11ea-0a73-e9ddb60ca291
# ╠═69fa7744-9b67-11ea-26df-3b4446dfb3ea
# ╠═af31a428-9adf-11ea-280a-45e2b891c4f9
# ╠═5ed7c444-9adf-11ea-2925-8573f018e820
# ╠═932b6b3c-a64d-11ea-2aba-2bf577ce3cf8
# ╟─030c1d10-9b69-11ea-11b7-ff04c60892b9
# ╠═d7bdab72-9b65-11ea-18c0-5353a214749d
# ╟─22992cec-9adb-11ea-078e-c7c21489c053
# ╠═5d723220-9ade-11ea-37db-c110dda60a15
# ╠═632cb26c-9ade-11ea-1bc7-39b8207190e2
# ╠═a01bf430-9ade-11ea-2ae4-23287ba11406
# ╠═69e045b0-9ade-11ea-0c55-05fa0da5893c
# ╟─054e0c4e-9adf-11ea-3deb-4daf2b6a2548
# ╠═91b4eedc-9adf-11ea-37aa-250ceec26640
# ╟─a7abf64e-9adb-11ea-2ae4-47886125fe60
# ╟─46388876-9ae2-11ea-2c5f-073698e45d44
# ╟─a9cdba00-9ae2-11ea-3bf9-41d07e7a785f
# ╟─f22b6fda-9ae3-11ea-3ff2-ebcf1374f595

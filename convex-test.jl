## Start
print("the convex-hull of a space")
## random N points
boundary = 0:100
points = [15, 25, 80, 75, 50, 30, 35, 15, 25, 35]
plot(points, boundary)

# random points
begin
	domain = rand(1:100, 10)
	range = rand(1:100, 10)
end
# plots
scatter(range, domain, legend=false)



// Sort a list of numbers.
function qsort(l) = len(l)<=1 ? l : concat(
	qsort([ for (x=l) if (x<l[0]) x ]),
	[ for (x=l) if (x==l[0]) x ],
	qsort([ for (x=l) if (x>l[0]) x]));

// Collapse runs of duplicates from a list.
function uniq(l) = [ l[0], for (i=[1:1:len(l)-1]) if (l[i]!=l[i-1]) l[i] ];

// Project on the i'th axis so lookup() can be used.
function curve_prj(c,i) = [ for (v=c) [v[0],v[1][i]] ];

// Establish periodicity of lookup() by extending to <=0 and >=1 as needed.
function curve_extend(c) = [
	if (c[0][0]>0) [c[len(c)-1][0]-1,c[len(c)-1][1]],
	for (p=c) p,
	if (c[len(c)-1][0]<1) [c[0][0]+1,c[0][1]] ];

// Evaluate curve at parameter t using lookup() to interpolate.
function curve_pt(c,t) = let(
	a=curve_extend(c))
	[ lookup(t,curve_prj(a,0)), lookup(t,curve_prj(a,1)), lookup(t,curve_prj(a,2)) ];

// Interpolate parametric curves to produce a new parametric curve.
function curve_morph(c1,c2,s) =
	let(partition = uniq(qsort([ 0, for (c=[c1,c2], p=c) p[0], 1 ])))
	[ for (t=partition) [ t,(1-s)*curve_pt(c1,t) + s*curve_pt(c2,t) ] ];

// Internal core function for loft operation.
module loft_core(curves,cap_start=false,cap_end=false) {
	partition = uniq(qsort([ for (c=curves, v=c) v[0], 1 ]));
	m = len(curves);
	n = len(partition);
	edge_points = [ for (c=curves, t=partition) curve_pt(c,t) ];
	center_points = [ for (k=[0:len(curves)-1], j=[0:1:n-2])
		(edge_points[n*k+j] + edge_points[n*(k+1)+j+1] +
		 edge_points[n*(k+1)+j] + edge_points[n*k+j+1])/4 ];
	points = [ for (p=edge_points) p, for (p=center_points) p ];
	c0 = len(edge_points);
	faces = [
		for (k=[0:1:len(curves)-2], j=[0:n-2],
			v=[ [k*n+j, (k+1)*n+j, c0+k*(n-1)+j],
			    [(k+1)*n+j, (k+1)*n+j+1, c0+k*(n-1)+j],
			    [(k+1)*n+j+1, k*n+j+1, c0+k*(n-1)+j],
			    [k*n+j+1, k*n+j, c0+k*(n-1)+j] ]) v,
		if (cap_start) [ for (j=[n-2:-1:0]) j ],
		if (cap_end) [ for (j=[0:1:n-2]) n*(m-1)+j ],
	];
	polyhedron(points=points,faces=faces,convexity=20);
}

// Produce a polyhedron-type object by applying a loft operation to
// a list of parametric curves, linking points in successive curves with
// the same value of the parameter. If the first or last curve is planar,
// it can be made into an end-cap surface by putting an empty curve []
// before or after it. Otherwise, either the first and last curves must
// be the same, producing a loop, or they must be degenerate (single points).
module loft(curves) {
	loft_core(
		curves = [for (c=curves) if (len(c)>0) c],
		cap_start = len(curves[0])==0,
		cap_end = len(curves[len(curves)-1])==0
	);
}

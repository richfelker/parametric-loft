
// Parametrize a star-convex curve by t=theta/360.
// The first point in the polygon becomes t=0.
function polar_parametrize(points,center=[0,0]) =
	let (p0=points[0], a0=atan2(p0[1]-center[1],p0[0]-center[0]))
	[ for (p=concat(points,[p0]))
	[ (atan2(p[1]-center[1],p[0]-center[0])-a0+720)%360/360, p ] ];

// Measure [partial] perimeter of polygon, through first n edges.
function perimeter(points,n=undef) =
	is_undef(n) ? perimeter(points,len(points)) :
	n==0 ? 0 :
	perimeter(points,n-1) + norm(points[n==len(points)?0:n]-points[n-1]);

// Parametrize an arbitrary curve by fraction of perimeter.
function length_parametrize(points) =
	let (total=perimeter(points)) [
	for (i=[0:1:len(points)-1]) [ perimeter(points,i)/total, points[i] ],
	[1, points[0]]];

// Parametrize an arbitrary curve by point index.
function indexed_parametrize(points,center=[0,0]) = [
	for (i=[0:1:len(points)-1]) [ i/len(points), points[i] ] ];

// Transform a parametrized curve in 2- or 3-space via an affine transformation
// matrix. Produces a parametrized curve in 3-space.
function transform_curve(M,c) = [ for (p=c) [ p[0],
	[[1,0,0,0],[0,1,0,0],[0,0,1,0]]*M*[p[1][0],p[1][1],is_undef(p[1][2])?0:p[1][2],1]
	] ];

// Produce a non-parametrized regular n-gon with first vertex on y axis.
function regular_ngon(n,r) = [ for (i=[0:1:n-1]) [-r*sin(360*i/n),r*cos(360*i/n),0] ];


// Matrix for rotation around an axis. Default is z-axis. If first argument
// is a vector, elements are sequential rotations around each axis.
function R(a,v=[0,0,1]) =
	!is_num(a) ? R(a[0],[1,0,0])*R(a[1],[0,1,0])*R(a[2],[0,0,1]) :
	let (id=[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],
	vcross=[[0,-v[2],v[1],0],[v[2],0,-v[0],0],[-v[1],v[0],0,0], [0,0,0,0]],
	vouter=[for (i=[0:2]) [for (j=[0:2]) v[i]*v[j],0], [0,0,0,1]])
	cos(a)*id + sin(a)*vcross + (1-cos(a))*vouter;

// Matrix for translation. Scalars are along the z axis.
function T(v=[0,0,0]) = is_num(v) ? T([0,0,v]) :
	[[1,0,0,v[0]],[0,1,0,v[1]],[0,0,1,v[2]],[0,0,0,1]];

// Matrix for scaling (dilation). Scalar applies same to each axis;
// vector scales each axis separately.
function S(k=1) = is_num(k) ? S([k,k,k]) :
	[[k[0],0,0,0],[0,k[1],0,0],[0,0,k[2],0],[0,0,0,1]];

use <../loft.scad>;
use <../pcurve.scad>;

// Mushroom. This could be done a lot nicer parametrically and separated
// out into separate OpenSCAD objects for the stem and cap, but as-is it
// demonstrates how the loft module can do non-convex "direction reversal"
// multiple times to construct complex objects as a single polyhedron.

loft([
	[],
	for (z=[0:1/4:8]) transform_curve(
		T([(pow(z-4,2)-16)/32,0,z])*R([0,2*z,0])*S(1-z/32),
		length_parametrize(regular_ngon(n=36,r=1))),
	for (z=[8:-1/4:5]) transform_curve(
		R([0,16,0])*T(z-8)*R([0,-16,0])*T(8)*R([0,16,0])*S(3/4+pow(z-8,2)),
		length_parametrize(regular_ngon(n=26,r=1))),
	for (z=[5.5:+1/8:9]) transform_curve(
		R([0,16,0])*T(z-8)*R([0,-16,0])*T(8)*R([0,16,0])*S(3/4+3+sqrt((9-z)*9)),
		length_parametrize(regular_ngon(n=36,r=1))),
	[],

]);

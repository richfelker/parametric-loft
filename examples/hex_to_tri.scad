use <../loft.scad>;
use <../pcurve.scad>;


loft([
	[],
	for (s=[0:1/8:1]) curve_morph(
		transform_curve(T(),length_parametrize(regular_ngon(n=6,r=10))),
		transform_curve(T(10)*R(15,[0,0,1]),length_parametrize(regular_ngon(n=3,r=6))),
		s),
	[],
]);

use <../loft.scad>;
use <../pcurve.scad>;

loft([
	[],
	for (z=[0:1/8:10]) transform_curve(
		T(z)*S(10+2*sqrt(z))*R(45),
		length_parametrize(regular_ngon(n=4,r=1/sqrt(2)))
	),
	for (z=[10:-1/8:2]) transform_curve(
		T(z)*S(10+2*sqrt(z)-2)*R(45),
		length_parametrize(regular_ngon(n=4,r=1/sqrt(2)))
	),
	[],
]);

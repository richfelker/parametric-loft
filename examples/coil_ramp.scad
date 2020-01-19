use <../loft.scad>;
use <../pcurve.scad>;

loft([
	[],
	for (i=[0:6:360*3])
		transform_curve(
			R(i)*T([30-i/60,0,20*i/360])*R(90,[1,0,0]),
			length_parametrize([
				[10,0],[-10,0],[-10,8],[-8,8],
				[-8,2],[8,2],[8,8],[10,8]
			])
		),
	[],
]);

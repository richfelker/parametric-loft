use <../loft.scad>;
use <../pcurve.scad>;


loft([
	for (i=[0:6:360])
		transform_curve(
			R(i)*T([20,0,0])*R(90,[1,0,0])*R(i/2),
			length_parametrize(regular_ngon(n=4,r=10))
		)
]);

# parametric-loft

This is a "loft" module for OpenSCAD, allowing complex 3D objects to
be built out of 2D curves. It's "parametric" in the sense that the 2D
curves it takes as input are defined as piecewise-linear periodic
functions from the interval [0,1] into 3-space, expressed as a vector
of `[t,[x,y,z]]` pairs. It does not operate on OpenSCAD 2D geometry
objects, since those objects are opaque to the language and their
properties are not accessible from within it.

The included `pcurve.scad` module provides functions for constructing
such curves from a list of points, parametrizing the curve by length,
angle around a center point (polar), or simply index in the list of
points. It also provides a function for applying affine
transformations to curves, and primitives for affine transformation
matrices compatible with OpenSCAD's `multmatrix` module.


## Constraints

The `loft` module takes a list (vector) of parametric curves, with an
optional `[]` element at the beginning and/or end of the list. If
present, the `[]` element is skipped and indicates that the initial or
final curve should itself be a surface. (This requires that all points
on the curve be coplanar.) If this feature is not being used, then the
initial and final curves must be degenerate (single point) curves so
that the resulting 3D object is a manifold, *or* the initial and final
curve can coincide exactly, producing a loop (toroid, knot, etc.).


## Output

The output of the `loft` module is an OpenSCAD `polyhedron` object in
the geometry. The domain (`t`-coordinate) points of all curves
involved in the loft are combined to produce a partition of `[0,1]`,
the curves are each evaluated at each partition point using linear
interpolation, and corresponding-`t`-coordinate points are connected
by edges. Since this may produce non-planar quads, four quads with an
interpolated center point are used.

This can produce unpleasant results with large degrees of "twist"
between successive curves. The `morph_curve` function in `loft.scad`
can be used to interpolate between curves to provide a "smoother" loft
operation at the cost of more processing overhead.


## Examples

See files in the `examples/` directory for examples of usage.

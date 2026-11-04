# swift-ray

Use this package when you need a half-line: a start point and a nonzero direction, evaluated only at non-negative parameters, over any point and displacement types you bring. Start from `Ray<Point, Displacement>`. For the infinite line in both directions, use `Line<Point, Displacement>` from swift-line, which every ray wraps and exposes as `Ray.line`. For a bounded piece between two points, use Segment from swift-segment.

## Laws

- A `Ray` is a `Line` restricted to non-negative parameters. The origin is the line's anchor, and the parameter is a `Magnitude<Parameter>`, so negative, infinite and NaN parameters are rejected before evaluation. Evaluating at zero gives the origin. To evaluate behind the origin, go through `Ray.line`.
- The direction is never zero. Construction and decoding both defer to `Line`, so they reject a zero direction in the same way.
- A `Ray` is a parameterization, not a set of points. Equality and hashing compare the origin and the direction exactly. Rays with the same origin and a scaled direction are unequal, even though they cover the same points.
- `Ray` has no setter for its direction, but assigning `Ray.line` replaces the direction along with the origin. Assigning `Ray.origin` moves only the anchor of the ray's own line, and the line the ray was built from is left as it was.
- The package does no arithmetic. `Ray.point(at:using:)` passes the origin, the direction and the unwrapped parameter to the caller's closure unchanged, without normalizing the direction, and any failure the closure throws reaches the caller as it was thrown.
- Encoding nests the line under the key `line`. Encoding and decoding are separate conformances, so each needs only its own capability from `Point` and `Displacement`.

# Ray

An anchored line restricted to nonnegative finite parameters. Line owns the
nonzero direction invariant; Magnitude owns the parameter invariant. Both are
publicly available through `import Ray`. A negative direction is valid: direction
sign and parameter sign are distinct. No automatic normalization is performed.

```swift
import Ray
let ray = try Ray(origin: 5, direction: -2)
let point = ray.point(at: try Magnitude(validating: 3)) { p, d, t in p + d * t }
// point == -1
```

The origin is included. `line` explicitly exposes the extension to signed
parameters. Equality compares origin and direction rather than geometric sets.
Coding uses a `line` field and delegates zero-direction rejection to Line.
Metric projection, containment tolerances, intersection, and platform math remain
explicit relationships. Point and displacement domain validity are inherited;
this type does not make invalid IEEE coordinates geometrically meaningful.

Production URL dependencies are Line and Magnitude. Point and Tagged are used
only by integration tests. Workspace registration and native verification are
pending safe workspace integration and GUI-backed native MCP execution.

Validation: registered in atoms.xcworkspace. GUI-backed native MCP umbrella
build-for-testing and all focused Ray/Ball/Orthotope tests passed on My Mac,
2026-09-08 21:01 (29 runtime cases total). See consolidation README for result
bundle and remaining phase work. Earlier pending-registration notes are superseded.

@_exported public import Line
@_exported public import Magnitude

/// A line parameterization restricted to nonnegative finite parameter values.
/// Direction scale matters, and the origin is included. No metric is selected.
public struct Ray<Point, Displacement: AdditiveArithmetic> {
    public var line: Line<Point, Displacement>

    /// Restrict an existing anchored line to nonnegative parameters.
    public init(line: Line<Point, Displacement>) { self.line = line }

    public var origin: Point {
        get { line.point }
        set { line.point = newValue }
    }

    public var direction: Displacement { line.direction }

    /// Evaluate using the supplied affine translation and scalar action.
    /// Magnitude owns the parameter's nonnegative and finite invariant.
    public func point<Parameter: Magnitude::Scalar, Failure: Swift.Error>(
        at parameter: Magnitude<Parameter>,
        using evaluate: (Point, Displacement, Parameter) throws(Failure) -> Point
    ) throws(Failure) -> Point {
        try line.point(at: parameter.value, using: evaluate)
    }
}

extension Ray: Equatable where Point: Equatable {}
extension Ray: Hashable where Point: Hashable, Displacement: Hashable {}
extension Ray: Sendable where Point: Sendable, Displacement: Sendable {}

#if !hasFeature(Embedded)
extension Ray: Encodable where Point: Encodable, Displacement: Encodable {}
extension Ray: Decodable where Point: Decodable, Displacement: Decodable {}
#endif

extension Ray {
    public init(origin: Point, direction: Displacement) throws(Line<Point, Displacement>.ValidationError) {
        line = try Line(point: origin, direction: direction)
    }
}

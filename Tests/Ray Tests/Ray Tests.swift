import Ray
import Testing
import Foundation
import Point
import Tagged

@Suite struct `Ray parameterization contracts` {
    @Test func `Zero directions are rejected by the line owner`() {
        #expect(throws: Line<Int, Int>.ValidationError.zeroDirection) {
            try Ray(origin: 1, direction: 0)
        }
    }

    @Test func `Evaluation includes the origin and preserves direction scale`() throws {
        let ray = try Ray(origin: 5, direction: -2)
        #expect(ray.point(at: Magnitude<Int>.zero) { p, d, t in p + d * t } == 5)
        #expect(ray.point(at: try Magnitude(validating: 3)) { p, d, t in p + d * t } == -1)
        #expect(ray.line.point(at: -1) { p, d, t in p + d * t } == 7)
    }

    @Test(arguments: [-1.0, .infinity, .nan])
    func `Invalid ray parameters fail before evaluation`(_ value: Double) {
        #expect(throws: Magnitude<Double>.Error.self) { try Magnitude(validating: value) }
    }

    @Test func `Restricting a line preserves representation and origin mutation`() throws {
        let line = try Line(point: "start", direction: Duration.seconds(2))
        var ray = Ray(line: line)
        #expect(ray.line == line)
        ray.origin = "moved"
        #expect(ray.origin == "moved")
        #expect(ray.direction == line.direction)
        #expect(line.point == "start")
    }

    @Test func `Tagged three dimensional origins remain tagged`() throws {
        enum World {}
        typealias Position = Tagged<World, Point<3, Int>>
        let origin = Position(_unchecked: Point(x: 1, y: 2, z: 3))
        let ray = try Ray(origin: origin, direction: Vector(x: 1, y: 0, z: 0))
        let line: Line<Position, Vector<3, Int>> = ray.line
        #expect(line.point == origin)
    }

    @Test func `Equality distinguishes scaled and reversed directions`() throws {
        let ray = try Ray(origin: 0, direction: 2)
        #expect(ray != (try Ray(origin: 0, direction: 4)))
        #expect(ray != (try Ray(origin: 0, direction: -2)))
        #expect(ray != (try Ray(origin: 1, direction: 2)))
        #expect(Set([ray, ray]).count == 1)
    }

    @Test func `Evaluation propagates the supplied typed failure`() throws {
        enum Failure: Error { case overflow }
        let ray = try Ray(origin: 0, direction: 1)
        func evaluate(_ point: Int, _ direction: Int, _ parameter: Int) throws(Failure) -> Int {
            throw .overflow
        }
        #expect(throws: Failure.overflow) {
            try ray.point(at: Magnitude<Int>.zero, using: evaluate)
        }
    }

    @Test func `Coding conformances do not require each other`() throws {
        struct EncodeOnly: Encodable { let value: Int }
        struct DecodeOnly: Decodable { let value: Int }
        let ray = try Ray(origin: EncodeOnly(value: 7), direction: -2)
        let data = try JSONEncoder().encode(ray)
        let decoded = try JSONDecoder().decode(Ray<DecodeOnly, Int>.self, from: data)
        #expect(decoded.origin.value == 7)
        #expect(decoded.direction == -2)
    }

    @Test func `Coding preserves the line invariant`() throws {
        let ray = try Ray(origin: 2, direction: 3)
        #expect(try JSONDecoder().decode(Ray<Int, Int>.self, from: JSONEncoder().encode(ray)) == ray)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Ray<Int, Int>.self, from: Data(#"{"line":{"point":2,"direction":0}}"#.utf8))
        }
    }
}

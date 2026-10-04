module DrugDealer.Spawn

// -----------------------------------------------------------------------------
// Formations - DrugDealer
// -----------------------------------------------------------------------------
// Pick a formation by NPC count.
public func MakeFormation(center: Vector4, count: Int32, distance: Float) -> array<Vector4> {
    switch count {
        case 2:
            return Duo(center, distance);
        case 3:
            return Triangle(center, distance);
        case 4:
            return Square(center, distance);
        case 5:
            return SquareWithCenter(center, distance);
        case 6:
            return Hexagon(center, distance);
        default:
            return Circle(center, count, distance);
    }
}

private func Polygon(center: Vector4, sides: Int32, distance: Float) -> array<Vector4> {
    let positions: array<Vector4>;
    let i = 0;
    while i < sides {
        let angle = Cast<Float>(i) / Cast<Float>(sides) * 6.2831855;
        ArrayPush(positions, ApplyRandomization(center, angle, distance));
        i += 1;
    }
    return positions;
}

private func Duo(center: Vector4, distance: Float) -> array<Vector4> {
    let radius = distance * 0.5;
    return [ApplyRandomization(center, 0.0, radius), ApplyRandomization(center, 3.1415927, radius)];
}

private func Triangle(center: Vector4, distance: Float) -> array<Vector4> = Polygon(center, 3, distance);

private func Square(center: Vector4, distance: Float) -> array<Vector4> = Polygon(center, 4, distance);

private func Hexagon(center: Vector4, distance: Float) -> array<Vector4> = Polygon(center, 6, distance);

private func SquareWithCenter(center: Vector4, distance: Float) -> array<Vector4> {
    let positions = Square(center, distance);
    ArrayInsert(positions, 0, center);
    return positions;
}

// What was there before
private func Circle(center: Vector4, count: Int32, distance: Float) -> array<Vector4> {
    let positions: array<Vector4>;
    let i = 0;
    while i < count {
        if i > 0 {
            let angle = Cast<Float>(i) / Cast<Float>(count) * 6.2831;
            ArrayPush(positions, ApplyRandomization(center, angle, distance));
        } else {
            ArrayPush(positions, center);
        }
        i += 1;
    }
    return positions;
}

// To look more natural
private func ApplyRandomization(center: Vector4, baseAngle: Float, radius: Float) -> Vector4 {
    let angle = baseAngle + RandRangeF(-0.12, 0.12);
    let jitteredRadius = radius - RandRangeF(0.0, 0.3);
    let pos = center;
    pos.X += CosF(angle) * jitteredRadius;
    pos.Y += SinF(angle) * jitteredRadius;
    return pos;
}


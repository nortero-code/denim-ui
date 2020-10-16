import math
import options
import types
import ../vec
import ../rect
import ../utils

proc createTextPrimitive*(
  self: Element,
  text: string,
  pos: Point = vec2(0.0,0.0),
  color: string = "white",
  fontSize: float = 12.0,
  font: string = "system-ui",
  textBaseline: string = "top",
  alignment: string = "left"
): Primitive =
  let textInfo = TextInfo(text: text, fontSize: fontSize, textBaseline: textBaseline, font: font, pos: pos, alignment: alignment)
  Primitive(
    transform: self.props.transform,
    bounds: self.bounds.get(),
    clipToBounds: self.props.clipToBounds.get(false),
    kind: Text,
    textInfo: textInfo,
    colorInfo: ColorInfo(fill: color),
    children: @[],
  )

proc moveTo*(x: float, y: float): PathSegment =
  PathSegment(kind: MoveTo, to: vec2(x,y))
proc lineTo*(x: float, y: float): PathSegment =
  PathSegment(kind: LineTo, to: vec2(x,y))
proc curveTo*(cpx: float, cpy: float, x: float, y: float): PathSegment =
  PathSegment(kind: QuadraticCurveTo, controlPoint: vec2(cpx, cpy), point: vec2(x, y))
proc close*(): PathSegment =
  PathSegment(kind: Close)

proc createPath*(self: Element, colorInfo: Option[ColorInfo], strokeInfo: Option[StrokeInfo], segments: seq[PathSegment]): Primitive =
  Primitive(
    transform: self.props.transform,
    bounds: self.bounds.get(),
    clipToBounds: self.props.clipToBounds.get(false),
    kind: Path,
    segments: @segments,
    colorInfo: colorInfo,
    strokeInfo: strokeInfo,
    children: @[],
  )

proc createPath*(self: Element, colorInfo: Option[ColorInfo], strokeInfo: Option[StrokeInfo], segments: varargs[PathSegment]): Primitive =
  Primitive(
    transform: self.props.transform,
    bounds: self.bounds.get(),
    clipToBounds: self.props.clipToBounds.get(false),
    kind: Path,
    segments: @segments,
    colorInfo: colorInfo,
    strokeInfo: strokeInfo,
    children: @[],
  )

proc circle*(self: Element, colorInfo: Option[ColorInfo], strokeInfo: Option[StrokeInfo], center: Point, radius: float): Primitive =
  Primitive(
    transform: self.props.transform,
    bounds: self.bounds.get(),
    clipToBounds: self.props.clipToBounds.get(false),
    kind: Circle,
    colorInfo: colorInfo,
    strokeInfo: strokeInfo,
    circleInfo: CircleInfo(center: center, radius: radius),
    children: @[],
  )

proc ellipse*(self: Element, colorInfo: Option[ColorInfo], strokeInfo: Option[StrokeInfo], center: Point, radius: Vec2[float]): Primitive =
  Primitive(
    transform: self.props.transform,
    bounds: self.bounds.get(),
    clipToBounds: self.props.clipToBounds.get(false),
    kind: Ellipse,
    colorInfo: colorInfo,
    strokeInfo: strokeInfo,
    ellipseInfo: EllipseInfo(center: center, radius: radius, endAngle: TAU),
    children: @[],
  )

proc rectangle*(self: Element, colorInfo: Option[ColorInfo], strokeInfo: Option[StrokeInfo]): Primitive =
  Primitive(
    transform: self.props.transform,
    bounds: self.bounds.get(),
    clipToBounds: self.props.clipToBounds.get(false),
    kind: Rectangle,
    colorInfo: colorInfo,
    strokeInfo: strokeInfo,
    rectangleInfo: RectangleInfo(bounds: self.bounds.get()),
    children: @[],
  )

proc rectangle*(bounds: Bounds, colorInfo: Option[ColorInfo], strokeInfo: Option[StrokeInfo]): Primitive =
  Primitive(
    kind: Rectangle,
    colorInfo: colorInfo,
    strokeInfo: strokeInfo,
    rectangleInfo: RectangleInfo(bounds: bounds),
    children: @[],
  )

proc fillColor*(color: Color): ColorInfo =
  ColorInfo(fill: some(color))

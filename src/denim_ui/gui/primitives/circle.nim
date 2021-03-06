import options, sugar
import ../types
import ../element
import ../drawing_primitives
import ../../vec
import ../../utils
import ../../type_name
import ../world_position

type
  CircleProps* = ref object
    color*: Option[Color]
    radius*: float
    stroke*: Option[Color]
    strokeWidth*: Option[float]
    lineDash*: Option[LineDash]
    lineCap*: Option[LineCap]
    lineJoin*: Option[LineJoin]

  Circle* = ref object of Element
    circleProps*: CircleProps

implTypeName(Circle)

method render(self: Circle): Option[Primitive] =
  let props = self.circleProps
  let worldPos = self.actualWorldPosition()
  some(
    self.circle(
      some(ColorInfo(fill: props.color, stroke: props.stroke)),
      some(StrokeInfo(
        width: props.strokeWidth.get(1.0),
        lineDash: props.lineDash,
        lineCap: props.lineCap,
        lineJoin: props.lineJoin
      )),
      worldPos,
      props.radius
    )
  )

method measureOverride*(self: Circle, availableSize: Vec2[float]): Vec2[float] =
  let props = self.circleProps
  let diameter = props.radius * 2.0
  vec2(max(diameter, self.props.width.get(0.0)), max(diameter, self.props.height.get(0.0)))

proc createCircle*(props: (ElementProps, CircleProps)): Circle =
  result = Circle(
    circleProps: props[1]
  )
  initElement(result, props[0])

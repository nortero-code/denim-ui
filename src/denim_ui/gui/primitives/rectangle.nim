import strformat, options, sugar
import ../types
import ../element
import ../drawing_primitives
import ../../vec
import ../../rect
import ../../type_name

type
  RectangleElem* = ref object of Element
    rectangleProps*: RectangleProps

  RectangleProps* = ref object
    color*: Option[Color]
    alpha*: Option[byte]
    radius*: Option[CornerRadius]
    stroke*: Option[Color]
    strokeWidth*: Option[float]
    lineDash*: Option[LineDash]
    lineCap*: Option[LineCap]
    lineJoin*: Option[LineJoin]

implTypeName(RectangleElem)

method render(self: RectangleElem): Option[Primitive] =
  let
    props = self.rectangleProps
    bounds = self.bounds.get()
    width = bounds.width()
    height = bounds.height()
    radius = props.radius.get((0.0, 0.0, 0.0, 0.0))

  some(
    self.createPath(
      some(ColorInfo(
        fill: props.color,
        stroke: props.stroke,
        alpha: props.alpha,
      )),
      some(StrokeInfo(
        width: props.strokeWidth.get(1.0),
        lineDash: props.lineDash,
        lineCap: props.lineCap,
        lineJoin: props.lineJoin
      )),
      moveTo(radius[0], 0),
      lineTo(width - radius[1], 0),
      quadraticCurveTo(width, 0, width, radius[1]),
      lineTo(width, height - radius[2]),
      quadraticCurveTo(width, height, width - radius[2], height),
      lineTo(radius[3], height),
      quadraticCurveTo(0, height, 0, height - radius[3]),
      lineTo(0, radius[0]),
      quadraticCurveTo(0, 0, radius[0], 0),
      close()
    )
  )

proc createRectangle*(props: (ElementProps, RectangleProps)): RectangleElem =
  let (elemProps, rectProps) = props
  result = RectangleElem(
    rectangleProps: rectProps
  )
  initElement(result, elemProps)

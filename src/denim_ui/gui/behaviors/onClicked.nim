import sugar
import options
import tables
import ../behaviors
import ../element
import ../element_events
import ../../guid
import ../../events

type
  ClickedHandler* = (Element, PointerArgs, var EventResult) -> void

let behaviorId = genGuid()

var clickedHandlers = initTable[Element, seq[ClickedHandler]]()

proc onClicked*(handler: ClickedHandler, force: bool = false): Behavior =
  Behavior(
    added: some(
      proc(element: Element): void =
        if not clickedHandlers.hasKey(element):
          var pressed = false

          proc onLostCapture() =
            pressed = false
            echo "Clicked lost capture"

          element.onPointerPressed(
            proc(arg: PointerArgs, res: var EventResult): void =
              if arg.pointerIndex == PointerIndex.Primary:
                pressed = true
          )
          element.onPointerReleased(
            proc(args: PointerArgs, res: var EventResult): void =
              if pressed and (force or not res.isHandled()):
                for handler in clickedHandlers[element]:
                  handler(element, args, res)
              pressed = false
          )

        clickedHandlers.mgetorput(element, @[]).add(handler)
    )
  )

import options, sequtils, types

proc bringToFront*(self: Element): void =
  assert(self.parent.isSome)
  # TODO: We should probably normalize all zIndexes every once in a while.
  let largestZIndex = self.parent.get().children.foldl(max(a, b.props.zIndex.get(0)), low(int))
  # TODO: Do not increase z index if self is already in front
  self.props.zIndex = some(largestZIndex + 1)

/// Takes two dictionaries and produces a third, with all keys of the first and
/// second. Key collisions will favor the second dictionary.
public func + <K,V>(left: [K:V], right: [K:V]) -> [K:V] {
  var dict = left

  for (k, v) in right {
    dict[k] = v
  }

  return dict
}

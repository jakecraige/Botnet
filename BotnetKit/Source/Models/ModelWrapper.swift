/// This class is used to map a model into an AnyObject instance where CocoaTouch APIs require it
public final class ModelWrapper<Model: Modelable> {
  public let model: Model

  public init(_ model: Model) {
    self.model = model
  }
}

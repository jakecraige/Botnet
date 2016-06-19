import UIKit
import Reusable
import RxSwift
import RxCocoa

extension UITableView {
  public func rx_itemsWithCellIdentifier
    <S: SequenceType, Cell: UITableViewCell, O: ObservableType where O.E == S, Cell: Reusable>
    (cellType: Cell.Type = Cell.self)
    -> (source: O)
    -> (configureCell: (Int, S.Generator.Element, Cell) -> Void)
    -> Disposable {
      return rx_itemsWithCellIdentifier(cellType.reuseIdentifier)
  }

  func deselectAllRows(animated: Bool) {
    indexPathsForSelectedRows?.forEach { indexPath in
      deselectRowAtIndexPath(indexPath, animated: animated)
    }
  }
}

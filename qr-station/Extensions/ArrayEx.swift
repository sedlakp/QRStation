//
//  ArrayEx.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation

extension Array where Element: Equatable {

  mutating func remove(_ object: Element) {
      guard let index = firstIndex(of: object) else {return}
      remove(at: index)
  }

}

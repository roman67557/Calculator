//
//  ItemSection.swift
//  Calculator
//
//  Created by Роман on 06.10.2022.
//

import RxDataSources

struct ItemSection<T> {
  var header: String
  var items: [T]
}

extension ItemSection: SectionModelType {
  typealias Item = T
  init(original: ItemSection, items: [T]) {
    self = original
    self.items = items
  }
}

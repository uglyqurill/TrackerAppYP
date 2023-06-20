//
//  TrackerYPTests.swift
//  TrackerYPTests
//
//  Created by Кирилл Брызгунов on 18.06.2023.
//
import SnapshotTesting
import XCTest
@testable import TrackerYP

class MyViewControllerTests: XCTestCase {
  func testMyViewController() {
    let trackersViewController = TrackersViewController()

    assertSnapshot(matching: trackersViewController, as: .image, record: false)
  }
}

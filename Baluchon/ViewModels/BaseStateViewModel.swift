//
//  BaseStateViewModel.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 31/01/2022.
//
import Foundation
import RxSwift
import RxRelay

open class BaseStateViewModel<S>: NSObject {
  private var stateRelay: BehaviorRelay<S>
  let disposeBag = DisposeBag()

  init(initialState: S) {
    stateRelay = BehaviorRelay(value: initialState)
    stateRelay.accept(initialState)
  }

  public func getStateChanges() -> Observable<S> {
    stateRelay
      .asObservable()
  }

  func updateState(closure: ((inout S) -> Void)) {
    var state = self.stateRelay.value
    closure(&state)
    self.stateRelay.accept(state)
  }

  public func getCurrentState() -> S {
    self.stateRelay.value
  }
}

open class BaseStateActionViewModel<S, A>: BaseStateViewModel<S> {
  private var actionRelay: BehaviorRelay<A>
  public var action: A {
    set {
      actionRelay.accept(newValue)
    }
    get {
      actionRelay.value
    }
  }

  init(initialState: S, initialAction: A) {
    actionRelay = BehaviorRelay(value: initialAction)

    super.init(initialState: initialState)
    actionRelay.accept(initialAction)
  }

  func getActionChanges(closure: @escaping ((A) -> Void)) {
    actionRelay
      .asObservable()
      .observe(on: MainScheduler.instance)
      .subscribe { action in
        guard let action = action.element else { return }
        closure(action)
      }.disposed(by: disposeBag)
  }
}

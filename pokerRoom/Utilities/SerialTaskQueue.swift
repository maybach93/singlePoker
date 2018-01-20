//
//  SerialTaskQueue.swift
//  OpenLife
//

import Foundation

public typealias TaskClosure = (_ completion: @escaping () -> Void) -> Void

public final class SerialTaskQueue {
    public private(set) var isBusy = false
    public private(set) var isStopped = true
    
    private var tasksQueue = [TaskClosure]()
    
    public init() {}
    
    public func addTask(_ task: @escaping TaskClosure) {
        self.tasksQueue.append(task)
        self.maybeExecuteNextTask()
    }
    
    public func start() {
        self.isStopped = false
        self.maybeExecuteNextTask()
    }
    
    public func stop() {
        self.isStopped = true
    }
    
    public func flushQueue() {
        self.tasksQueue.removeAll()
    }
    
    public var isEmpty: Bool {
        return self.tasksQueue.isEmpty
    }
    
    private func maybeExecuteNextTask() {
        if !self.isStopped && !self.isBusy {
            if !self.isEmpty {
                let firstTask = self.tasksQueue.removeFirst()
                self.isBusy = true
                firstTask({ [weak self] () -> Void in
                    self?.isBusy = false
                    self?.maybeExecuteNextTask()
                })
            }
        }
    }
}

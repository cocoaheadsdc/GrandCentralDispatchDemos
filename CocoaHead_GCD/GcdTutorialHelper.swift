//
//  GcdTutorialHelper.swift
//  CocoaHead_GCD
//
//  Created by Singh, Hardip on 4/3/16.
//

import Foundation


class GcdTutorialHelper {

    private let DemoFolder = "/Users/singhh/Desktop/gcd_dispatch_sources_demo"

    private let closureOne = {
        print("one")
    }

    private let closureTwo = {
        print("two")
        print("two")
        print("two")
        print("two")
        print("two")
    }

    private let closureThree = {
        print("three")
    }

    private let concurrentQueue = dispatch_queue_create("com.cocoaheads.gcdTalk.concurrent", DISPATCH_QUEUE_CONCURRENT)
    private let serialQueue = dispatch_queue_create("com.cocoaheads.gcdTalk.serial", DISPATCH_QUEUE_SERIAL)

    private var demoTimer: dispatch_source_t?
    private var demoFileDescriptorSource: dispatch_source_t?

    private var dispatchOnceToken: dispatch_once_t = 0

    private var demoIOChannel: dispatch_io_t?

}


// MARK: Dispatch Queue Demos
extension GcdTutorialHelper {
    func runConcurrentAsyncDemo() {
        dispatch_async(concurrentQueue, closureOne)
        dispatch_async(concurrentQueue, closureTwo)
        dispatch_async(concurrentQueue, closureThree)
    }

    func runSerialAsyncDemo() {
        dispatch_async(serialQueue, closureOne)
        dispatch_async(serialQueue, closureTwo)
        dispatch_async(serialQueue, closureThree)
    }

    func runConcurrentSyncDemo() {
        dispatch_sync(concurrentQueue, closureOne)
        dispatch_sync(concurrentQueue, closureTwo)
        dispatch_sync(concurrentQueue, closureThree)
    }

    func runSerialSyncDemo() {
        dispatch_sync(serialQueue, closureOne)
        dispatch_sync(serialQueue, closureTwo)
        dispatch_sync(serialQueue, closureThree)
    }
}

// Mark: Once / After Demo
extension GcdTutorialHelper {
    func runDispatchOnceDemo() {
        dispatch_once(&dispatchOnceToken) {
            print("once and only once")
        }
    }

    func runDispatchAfterDemo() {
        let delayInSeconds = 5.0
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, serialQueue) {
            print("delayed dispatch")
        }
    }
}

// MARK: Dispatch Group Demos
extension GcdTutorialHelper {
    func runGroupAsyncDemo() {
        let demoGroup = dispatch_group_create()

        dispatch_group_async(demoGroup, concurrentQueue) { [weak self] in
            self?.closureOne()
        }

        dispatch_group_async(demoGroup, serialQueue) { [weak self] in
            self?.closureTwo()
        }

        dispatch_group_async(demoGroup, concurrentQueue) { [weak self] in
            self?.closureThree()
        }

        dispatch_group_notify(demoGroup, dispatch_get_main_queue()) {
            print("group notification")
        }

        dispatch_group_wait(demoGroup, DISPATCH_TIME_FOREVER)
    }

    func runGroupAsyncFallsShortDemo() {
        let demoGroup = dispatch_group_create()

        dispatch_group_async(demoGroup, concurrentQueue) { [weak self] in
            self?.closureOne()
        }

        dispatch_group_async(demoGroup, serialQueue) { [weak self] in
            self?.closureTwo()
        }

        dispatch_group_async(demoGroup, concurrentQueue) { [weak self] in
            self?.closureThree()
        }

        dispatch_group_async(demoGroup, serialQueue) { [weak self] in
            self?.doSomethingWithAsyncCompletion(self?.serialQueue, completionClosure: {
            })
        }

        dispatch_group_notify(demoGroup, dispatch_get_main_queue()) {
            print("group notification")
        }

        dispatch_group_wait(demoGroup, DISPATCH_TIME_FOREVER)
    }

    func runGroupEnterLeaveDemo() {
        let demoGroup = dispatch_group_create()

        let closureOneWithGroupDeparture = {
            self.closureOne()
            dispatch_group_leave(demoGroup)
        }

        let closureTwoWithGroupDeparture = {
            self.closureTwo()
            dispatch_group_leave(demoGroup)
        }

        let closureThreeWithGroupDeparture = {
            self.closureThree()
            dispatch_group_leave(demoGroup)
        }

        dispatch_group_enter(demoGroup)
        dispatch_async(concurrentQueue, closureOneWithGroupDeparture)

        dispatch_group_enter(demoGroup)
        dispatch_async(concurrentQueue, closureTwoWithGroupDeparture)

        dispatch_group_enter(demoGroup)
        dispatch_sync(serialQueue, closureTwoWithGroupDeparture)

        dispatch_group_enter(demoGroup)
        dispatch_sync(serialQueue, closureThreeWithGroupDeparture)

        dispatch_group_enter(demoGroup)
        dispatch_group_async(demoGroup, serialQueue) { [weak self] in
            self?.doSomethingWithAsyncCompletion(self?.serialQueue, completionClosure: {
                dispatch_group_leave(demoGroup)
            })
        }

        dispatch_group_notify(demoGroup, dispatch_get_main_queue()) {
            print("group notification")
        }

        dispatch_group_wait(demoGroup, DISPATCH_TIME_FOREVER)
    }
    
    private func doSomethingWithAsyncCompletion(queueToUse: dispatch_queue_t?, completionClosure: ()->()) {
        guard let queueToUse = queueToUse else {
            completionClosure()
            return
        }

        dispatch_async(queueToUse, {
            for i in 1...5 {
                print(i)
                sleep(1)
            }
            completionClosure()
        })
    }
}

// MARK: Dispatch Semaphore Demo
extension GcdTutorialHelper {
    func runSemaphoreDemo(semThreadCount: Int) {
        let demoSemaphore = dispatch_semaphore_create(semThreadCount)

        for i in 1...4 {
            dispatch_async(concurrentQueue, {[weak self] in
                dispatch_semaphore_wait(demoSemaphore, DISPATCH_TIME_FOREVER)
                print("starting run \(i)")
                self?.doSomethingWithAsyncCompletion(self?.concurrentQueue, completionClosure: {
                    dispatch_semaphore_signal(demoSemaphore)
                })
            })
        }
    }
}

extension GcdTutorialHelper {
    func runDispatchObjectDemo() {
        // TODO
    }
}

// MARK: Dispatch Barrier Demos
extension GcdTutorialHelper {
    func runBarrierDemo(withBarrier: Bool) {
            dispatch_async(concurrentQueue) {
                for i in 1...5 {
                    print(i)
                    sleep(1)
                }
            }

        if withBarrier {
            dispatch_barrier_async(concurrentQueue) {
                print("in the barrier")
            }
        }

        for i in 6...10 {
            dispatch_async(concurrentQueue) {
                print(i)
                sleep(1)
            }
        }
    }
}

// MARK: Dispatch Sources Demos
extension GcdTutorialHelper {
    func startDemoTimer() {
        guard let demoTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, serialQueue) else {
            print("error creating demo timer")
            return
        }
        dispatch_source_set_timer(demoTimer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC)
        dispatch_source_set_event_handler(demoTimer) {
            print("timer event fired: \(NSDate())")
        }
        dispatch_resume(demoTimer)
        print("demo timer started")
        self.demoTimer = demoTimer
    }

    func stopDemoTimer() {
        if let demoTimer = demoTimer {
            dispatch_source_cancel(demoTimer)
            print("demo timer stopped")
            self.demoTimer = nil
        }
    }

    func startDemoFolderMonitor() {
        let demoFileDescriptor = open(DemoFolder, O_EVTONLY)

        guard let demoFileDescriptorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
            UInt(demoFileDescriptor),
            DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE,
            serialQueue) else {
                print("could not create demoFileDescriptorSource")
                return
        }

        dispatch_source_set_event_handler(demoFileDescriptorSource) {
            print("change in folder detected")
        }

        dispatch_source_set_cancel_handler(demoFileDescriptorSource) {
            print("directory monitor stopped")
        }

        dispatch_resume(demoFileDescriptorSource)
        print("folder monitor started")
        self.demoFileDescriptorSource = demoFileDescriptorSource
    }

    func stopDemoFolderMonitor() {
        if let demoFileDescriptorSource = demoFileDescriptorSource {
            dispatch_source_cancel(demoFileDescriptorSource)
        }
    }
}

// MARK: Dispatch I/O Demos
extension GcdTutorialHelper {
    func runDispatchIOReadExample() {
        let demoFile: NSString = DemoFolder + "/demoIOReadFile.txt"

        demoIOChannel = dispatch_io_create_with_path(DISPATCH_IO_RANDOM, demoFile.UTF8String, O_RDONLY, 0, serialQueue) { [weak self] (error)  in
            if error == 0 {
                self?.demoIOChannel = nil
            }
        }

        guard let demoIOChannel = demoIOChannel else {
            print("demoIOChannel was nil")
            return
        }

        dispatch_io_read(demoIOChannel, 0, 1024, serialQueue) { [weak self] (done, data, error) in
            if let data = data {
                var stringRead = ""
                dispatch_data_apply(data, { (region, offset, buffer, size) -> Bool in
                    let foo = NSString(bytes: buffer, length: size, encoding: NSUTF8StringEncoding) as! String
                    stringRead += foo

                    return true
                })
                print(stringRead)
            }

            if done {
                if let demoIOChannel = self?.demoIOChannel {
                    dispatch_io_close(demoIOChannel, DISPATCH_IO_STOP)
                }
            }
        }
    }

    func runDispatchIOWriteExample() {
        let demoFile: NSString = DemoFolder + "/demoIOWriteFile.txt"

        demoIOChannel = dispatch_io_create_with_path(DISPATCH_IO_RANDOM, demoFile.UTF8String, O_WRONLY, 0, serialQueue) { [weak self] (error)  in
            if error == 0 {
                self?.demoIOChannel = nil
            }
        }

        guard let demoIOChannel = demoIOChannel else {
            print("demoIOChannel was nil")
            return
        }

        let stringToWrite = "Goodbye, CocoaheadsDC"
        guard let nsDataToWrite = stringToWrite.dataUsingEncoding(NSUTF8StringEncoding) else {
            print("could not create NSData from stringToWrite")
            return
        }
        let dispatchDataToWrite = dispatch_data_create(nsDataToWrite.bytes, nsDataToWrite.length, nil, nil)

        dispatch_io_write(demoIOChannel, 0, dispatchDataToWrite, serialQueue) { (done, data_in_code_entry, error) in
            print("wrote data to demo IO file")
        }
    }
}









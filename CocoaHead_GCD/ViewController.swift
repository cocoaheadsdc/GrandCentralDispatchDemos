//
//  ViewController.swift
//  CocoaHead_GCD
//
//  Created by Singh, Hardip on 4/3/16.
//  Copyright © 2016 Washiington Post. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private enum TutorialSection: Int {
        case DispatchQueueSection
        case DispatchOnceAfterSection
        case DispatchGroupSection
        case DispatchSemaphoreSection
        case DispatchBarrierSection
        case DispatchSourcesSection
        case DispatchIOSection
    }

    private enum OnceAfterTutoriaRow: Int {
        case DispatchOnceRow
        case DispatchAfterRow
    }

    private enum QueueTutorialRow: Int {
        case ConcurrentRowAsync
        case SerialRowAsync
        case ConcurrentRowSync
        case SerialRowSync
    }

    private enum GroupTutorialRow: Int {
        case GroupAsyncRow
        case GroupAsyncFallsShortRow
        case GroupEnterLeaveRow
    }

    private enum SemaphoreTutorialRow: Int {
        case DispatchSingleAccessSemaphoreRow
        case DispatchDualAccessSemaphoreRow
    }

    private enum BarrierTutorialRow: Int {
        case WithoutBarrierRow
        case WithBarrierRow
    }

    private enum DispatchSourcesRow: Int {
        case StartDemoTimerRow
        case StopDemoTimerRow
        case StartDemoFolderMonitorRow
        case StopDemoFolderMonitorRow
    }

    private enum DispatchIORow: Int {
        case DispatchIOReadRow
        case DispatchIOWriteRow
    }

    private let gcdHelper = GcdTutorialHelper()
}

extension ViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.grayColor()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case TutorialSection.DispatchQueueSection.rawValue:
                return "Dispatch Queues"
            case TutorialSection.DispatchOnceAfterSection.rawValue:
                return "Dispatch Once / After"
            case TutorialSection.DispatchGroupSection.rawValue:
                return "Dispatch Groups"
            case TutorialSection.DispatchSemaphoreSection.rawValue:
                return "Dispatch Semaphores"
            case TutorialSection.DispatchBarrierSection.rawValue:
                return "Dispatch Barriers"
            case TutorialSection.DispatchSourcesSection.rawValue:
                return "Dispatch Sources"
            case TutorialSection.DispatchIOSection.rawValue:
                return "Dispatch IO / Data"
            default:
                return "Unknown Section"
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case TutorialSection.DispatchQueueSection.rawValue:
                return 4
            case TutorialSection.DispatchOnceAfterSection.rawValue:
                return 2
            case TutorialSection.DispatchGroupSection.rawValue:
                return 3
            case TutorialSection.DispatchSemaphoreSection.rawValue:
                return 2
            case TutorialSection.DispatchBarrierSection.rawValue:
                return 2
            case TutorialSection.DispatchSourcesSection.rawValue:
                return 4
            case TutorialSection.DispatchIOSection.rawValue:
                return 2
            default:
                return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell()

        switch indexPath.section {
            case TutorialSection.DispatchQueueSection.rawValue:
                switch indexPath.row {
                    case QueueTutorialRow.ConcurrentRowAsync.rawValue:
                        cell.textLabel?.text = "Concurrent Queue Async"
                    case QueueTutorialRow.SerialRowAsync.rawValue:
                        cell.textLabel?.text = "Serial Queue Async"
                    case QueueTutorialRow.ConcurrentRowSync.rawValue:
                        cell.textLabel?.text = "Concurrent Queue Sync"
                    case QueueTutorialRow.SerialRowSync.rawValue:
                        cell.textLabel?.text = "Serial Queue Sync"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            case TutorialSection.DispatchOnceAfterSection.rawValue:
                switch indexPath.row {
                    case OnceAfterTutoriaRow.DispatchOnceRow.rawValue:
                        cell.textLabel?.text = "Dispatch Once"
                    case OnceAfterTutoriaRow.DispatchAfterRow.rawValue:
                        cell.textLabel?.text = "Dispatch After"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            case TutorialSection.DispatchGroupSection.rawValue:
                switch indexPath.row {
                    case GroupTutorialRow.GroupAsyncRow.rawValue:
                        cell.textLabel?.text = "Dispatch Group Async"
                    case GroupTutorialRow.GroupAsyncFallsShortRow.rawValue:
                        cell.textLabel?.text = "Dispatch Group Async Falls Short"
                    case GroupTutorialRow.GroupEnterLeaveRow.rawValue:
                        cell.textLabel?.text = "Dispatch Group Enter/Leave"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            case TutorialSection.DispatchSemaphoreSection.rawValue:
                switch indexPath.row {
                    case SemaphoreTutorialRow.DispatchSingleAccessSemaphoreRow.rawValue:
                        cell.textLabel?.text = "Dispatch Semaphore (Single Access)"
                    case SemaphoreTutorialRow.DispatchDualAccessSemaphoreRow.rawValue:
                        cell.textLabel?.text = "Dispatch Semaphore (Dual Access)"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            case TutorialSection.DispatchBarrierSection.rawValue:
                switch indexPath.row {
                    case BarrierTutorialRow.WithoutBarrierRow.rawValue:
                        cell.textLabel?.text = "Without Barrier"
                    case BarrierTutorialRow.WithBarrierRow.rawValue:
                        cell.textLabel?.text = "With Barrier"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            case TutorialSection.DispatchSourcesSection.rawValue:
                switch indexPath.row {
                    case DispatchSourcesRow.StartDemoTimerRow.rawValue:
                        cell.textLabel?.text = "Start Dispatch Timer"
                    case DispatchSourcesRow.StopDemoTimerRow.rawValue:
                        cell.textLabel?.text = "Stop Dispatch Timer"
                    case DispatchSourcesRow.StartDemoFolderMonitorRow.rawValue:
                        cell.textLabel?.text = "Start Folder Monitor"
                    case DispatchSourcesRow.StopDemoFolderMonitorRow.rawValue:
                        cell.textLabel?.text = "Stop Folder Monitor"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            case TutorialSection.DispatchIOSection.rawValue:
                switch indexPath.row {
                    case DispatchIORow.DispatchIOReadRow.rawValue:
                        cell.textLabel?.text = "Dispatch I/O Read"
                    case DispatchIORow.DispatchIOWriteRow.rawValue:
                        cell.textLabel?.text = "Dispatch I/O Write"
                    default:
                        cell.textLabel?.text = "Unknown Cell"
                }
            default:
                cell.textLabel?.text = "Unknown Cell"
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\nstart...\n")

        switch indexPath.section {
            case TutorialSection.DispatchQueueSection.rawValue:
                switch indexPath.row {
                    case QueueTutorialRow.ConcurrentRowAsync.rawValue:
                        gcdHelper.runConcurrentAsyncDemo()
                    case QueueTutorialRow.SerialRowAsync.rawValue:
                        gcdHelper.runSerialAsyncDemo()
                    case QueueTutorialRow.ConcurrentRowSync.rawValue:
                        gcdHelper.runConcurrentSyncDemo()
                    case QueueTutorialRow.SerialRowSync.rawValue:
                        gcdHelper.runSerialSyncDemo()
                    default:
                        break
                }
            case TutorialSection.DispatchOnceAfterSection.rawValue:
                switch indexPath.row {
                    case OnceAfterTutoriaRow.DispatchOnceRow.rawValue:
                        gcdHelper.runDispatchOnceDemo()
                    case OnceAfterTutoriaRow.DispatchAfterRow.rawValue:
                        gcdHelper.runDispatchAfterDemo()
                    default:
                        break
                }
            case TutorialSection.DispatchGroupSection.rawValue:
                switch indexPath.row {
                    case GroupTutorialRow.GroupAsyncRow.rawValue:
                        gcdHelper.runGroupAsyncDemo()
                    case GroupTutorialRow.GroupAsyncFallsShortRow.rawValue:
                        gcdHelper.runGroupAsyncFallsShortDemo()
                    case GroupTutorialRow.GroupEnterLeaveRow.rawValue:
                        gcdHelper.runGroupEnterLeaveDemo()
                    default:
                        break
                }
            case TutorialSection.DispatchSemaphoreSection.rawValue:
                switch indexPath.row {
                    case SemaphoreTutorialRow.DispatchSingleAccessSemaphoreRow.rawValue:
                        gcdHelper.runSemaphoreDemo(1)
                    case SemaphoreTutorialRow.DispatchDualAccessSemaphoreRow.rawValue:
                        gcdHelper.runSemaphoreDemo(2)
                    default:
                        break
                }
            case TutorialSection.DispatchBarrierSection.rawValue:
                switch indexPath.row {
                    case BarrierTutorialRow.WithoutBarrierRow.rawValue:
                        gcdHelper.runBarrierDemo(false)
                    case BarrierTutorialRow.WithBarrierRow.rawValue:
                        gcdHelper.runBarrierDemo(true)
                    default:
                        break
                }
            case TutorialSection.DispatchSourcesSection.rawValue:
                switch indexPath.row {
                    case DispatchSourcesRow.StartDemoTimerRow.rawValue:
                        gcdHelper.startDemoTimer()
                    case DispatchSourcesRow.StopDemoTimerRow.rawValue:
                        gcdHelper.stopDemoTimer()
                    case DispatchSourcesRow.StartDemoFolderMonitorRow.rawValue:
                        gcdHelper.startDemoFolderMonitor()
                    case DispatchSourcesRow.StopDemoFolderMonitorRow.rawValue:
                        gcdHelper.stopDemoFolderMonitor()
                    default:
                        break
                }
            case TutorialSection.DispatchIOSection.rawValue:
                switch indexPath.row {
                    case DispatchIORow.DispatchIOReadRow.rawValue:
                        gcdHelper.runDispatchIOReadExample()
                    case DispatchIORow.DispatchIOWriteRow.rawValue:
                        gcdHelper.runDispatchIOWriteExample()
                    default:
                        break
                }
            default:
                break
        }
        print("\n...finish")
    }
}
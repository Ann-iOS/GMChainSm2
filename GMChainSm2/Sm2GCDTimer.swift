//
//  Sm2GCDTimer.swift
//  GMChainSm2
//
//  Created by iOS on 2021/10/26.
//

import Foundation

public typealias ActionBlock = () -> ()

public class Sm2GCDTimer {
    //单例
    public static let shared = Sm2GCDTimer()

    lazy var timerContainer = [String: DispatchSourceTimer]()

    /// GCD定时器
    ///
    /// - Parameters:
    ///   - name: 定时器名字
    ///   - timeInterval: 时间间隔
    ///   - queue: 队列
    ///   - repeats: 是否重复
    ///   - action: 执行任务的闭包
    public func scheduledDispatchTimer(WithTimerName name: String?, timeInterval: Double, queue: DispatchQueue, repeats: Bool, action: @escaping ActionBlock) {

        if name == nil {
            return
        }

        var timer = timerContainer[name!]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        //精度0.1秒
        timer?.schedule(deadline: .now(), repeating: timeInterval, leeway: DispatchTimeInterval.milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats == false {
                self?.cancleTimer(WithTimerName: name)
            }
        })
    }

    /// 取消定时器
    ///
    /// - Parameter name: 定时器名字
    public func cancleTimer(WithTimerName name: String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }


    /// 检查定时器是否已存在
    ///
    /// - Parameter name: 定时器名字
    /// - Returns: 是否已经存在定时器
    public func isExistTimer(WithTimerName name: String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }

}

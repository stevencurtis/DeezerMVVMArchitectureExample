//
//  FlowRoutingService.swift
//  DeezerProject
//
//  Created by Steven Curtis on 26/02/2021.
//

import UIKit

public protocol FlowRoutingServiceProtocol {
    var rootViewController: UIViewController { get }
    var visibleViewController: UIViewController { get }
    func showPushed(_ controller: UIViewController)
    func clearStackInBetween(left: UIViewController, right: UIViewController)
    func clearStackAndShowPushed(_ controllers: [UIViewController])
    func clearLastAndShowPushed(_ controller: UIViewController)
    func jumpBack(to controller: UIViewController?)
    func jumpBack(to controller: UIViewController, andPush next: UIViewController)
    func jumpBackToRoot()
    func replace(viewController: UIViewController, with controller: UIViewController)
    func showModel(
        _ controller: UIViewController,
        modelPresentationStyle: UIModalPresentationStyle?,
        closeHandler: (() -> Void)?
    )
    func showMusicBar()
    func hideMusicBar()
}

public final class FlowRoutingService {
    public let navigationController: UINavigationController
    public let tabController: MusicTabBar

    public init(navigationController: UINavigationController, tabController: MusicTabBar) {
        self.navigationController = navigationController
        self.tabController = tabController
    }
}

extension FlowRoutingService: FlowRoutingServiceProtocol {
    public func hideMusicBar() {
        tabController.hideMusicPlayer()
    }

    public func showMusicBar() {
        tabController.showMusicPlayer()
    }

    public var rootViewController: UIViewController {
        return navigationController.viewControllers.first!
    }

    public var visibleViewController: UIViewController {
        return navigationController.visibleViewController ?? navigationController.viewControllers.last!
    }

    public func clearStackInBetween(left: UIViewController, right: UIViewController) {
    let navigationController =
        self.navigationController.visibleViewController?.navigationController ?? self.navigationController
        let currentStack = navigationController.viewControllers
        guard let leftIndex = currentStack.firstIndex(of: left),
              let rightIndex = currentStack.firstIndex(of: right),
              leftIndex < rightIndex
        else { return }
        let newStack = Array(currentStack.prefix(leftIndex + 1)) + [right]
        clearStackAndShowPushed(newStack)
    }

    public func clearStackAndShowPushed(_ controllers: [UIViewController]) {
        if let visibleViewController = navigationController.visibleViewController {
            visibleViewController.navigationController?.setViewControllers(controllers, animated: true)
        } else {
            navigationController.setViewControllers(controllers, animated: false)
        }
    }

    public func showPushed(_ controller: UIViewController) {
        if let visibleViewController = navigationController.visibleViewController {
            visibleViewController.navigationController?.pushViewController(
                controller,
                animated: true
            )
        } else {
                navigationController.pushViewController(controller, animated: false)
        }
    }
    
    public func clearLastAndShowPushed(_ controller: UIViewController) {
        let navigationController: UINavigationController? = {
            if let visibleViewController = self.navigationController.visibleViewController {
                return visibleViewController.navigationController
            } else {
                return self.navigationController
            }
        }()
        guard let nvc = navigationController else { return }

        nvc.setViewControllers(Array(nvc.viewControllers.dropLast()) + [controller], animated: true)
    }

    public func jumpBack(to controller: UIViewController?) {
        if let controller = controller {
            if let topNav = visibleViewController.navigationController,
               topNav.viewControllers.contains(controller) {
                topNav.popToViewController(controller, animated: true)
            } else {
                navigationController.popToViewController(controller, animated: true)
            }
        } else {
            visibleViewController.navigationController?.popViewController(animated: true)
        }
    }

    public func jumpBack(to controller: UIViewController, andPush next: UIViewController) {
        guard let nav = visibleViewController.navigationController,
              let index = nav.viewControllers.firstIndex(of: controller)
        else {
            return
        }
        let stack = Array(nav.viewControllers.dropLast(nav.viewControllers.count - index - 1)) + [next]
        nav.setViewControllers(stack, animated: true)
    }

    public func jumpBackToRoot() {
        let navigationController = visibleViewController.navigationController ?? self.navigationController
        navigationController.popToRootViewController(animated: true)
    }

    public func replace(viewController: UIViewController, with controller: UIViewController) {
        guard
            let navigationController = visibleViewController.navigationController,
            let index = navigationController.viewControllers.firstIndex(of: viewController)
        else {
            return
        }
        navigationController.viewControllers[index] = controller
    }

    public func showModel(
        _ controller: UIViewController,
        modelPresentationStyle: UIModalPresentationStyle?,
        closeHandler: (() -> Void)?
    ) {
        if controller is UINavigationController
            || controller is UIAlertController {
            visibleViewController.present(controller, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: controller)
            if let modalPresentationStyle = modelPresentationStyle {
                navigationController.modalPresentationStyle = modalPresentationStyle
            }
            controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "close",
                style: .done,
                target: nil,
                action: nil
            )
        }
    }
}

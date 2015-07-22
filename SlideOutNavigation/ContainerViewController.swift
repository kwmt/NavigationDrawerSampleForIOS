//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
  case BothCollapsed
  case LeftPanelExpanded
  case RightPanelExpande
}

class ContainerViewController: UIViewController {
  
  
  var centerNavigationController: UINavigationController!
  var centerViewController: CenterViewController!
  
  var currentState = SlideOutState.BothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .BothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
  }
  var leftViewController: SidePanelViewController?
  let centerPanelExpandedOffset: CGFloat = 60
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self
    
    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)
    
    centerNavigationController.didMoveToParentViewController(self)
    
    
  }
  
  func showShadowForCenterViewController(shouldShowShadow: Bool){
    if shouldShowShadow {
      centerNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
  
}

// MARK: CenterViewController delegate

extension ContainerViewController:CenterViewControllerDelegate{
  func toggleLeftPanel() {
    let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
    if notAlreadyExpanded {
      addLeftPanelViewController()
    }
    animateLeftPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func toggleRightPanel() {
    
  }
  
  private func addLeftPanelViewController(){
    if leftViewController == nil {
      leftViewController = UIStoryboard.leftViewController()
      leftViewController!.animals = Animal.allCats()
      
      addChildSidePanelController(leftViewController!)
    }
    
  }
  
  private func addChildSidePanelController(sidePanelViewController: SidePanelViewController){
    view.insertSubview(sidePanelViewController.view, atIndex: 0)
    addChildViewController(sidePanelViewController)
    sidePanelViewController.didMoveToParentViewController(self)
  }
  
  
  func addRightPanelViewController(){
    
  }
  func animateLeftPanel(#shouldExpand:Bool){
    if shouldExpand {
      // 開く
      currentState = .LeftPanelExpanded
      
      animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
      
    } else {
      // 閉じる
      animateCenterPanelXPosition(targetPosition: 0) {
        finished in
        debugPrintln("finished:" ,finished)
        self.currentState = .BothCollapsed
        
        self.leftViewController!.view.removeFromSuperview()
        self.leftViewController = nil
      }
      
    }
    
  }
  func animateRightPanel(#shouldExpand:Bool){
    
  }
  
  func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
      self.centerNavigationController.view.frame.origin.x = targetPosition
    }, completion: completion)
  }
  
}



private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
  }
  
  class func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
  }
  
  class func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
  }
  
}
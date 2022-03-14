//
//  SwipeThroughPage.swift
//  ValentinesDay
//
//  Created by Christian Grinling on 07/02/2021.
//

import UIKit


class SwipeThroughPage: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

 var pageList:[UIViewController] = {
        
        let firstPage = FirstPage()
        let secondPage = SecondPage()
        let thirdPage = ThirdPage()
        let fourthPage = FourthPage()
        
        return [firstPage, secondPage, thirdPage, fourthPage]
        
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
        var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
            return pageList.firstIndex(of: vc ) ?? 0
      }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.navigationBar.isHidden = true
            //self.view.backgroundColor = .clear
            dataSource = self
            delegate = self
            let FirstPage = pageList[0]
            self.setViewControllers([FirstPage], direction: .forward, animated: true, completion: nil)
        }

        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let vcIndex = pageList.firstIndex(of: viewController) else {return nil}
            
            let previousIndex = vcIndex - 1
            
            guard previousIndex >= 0 else {return nil}
            
            guard pageList.count > previousIndex else {return nil}
            
            return pageList[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let vcIndex = pageList.firstIndex(of: viewController) else {return nil}
            
            let nextIndex = vcIndex + 1
            
            guard pageList.count != nextIndex else {return nil}
            
            guard pageList.count > nextIndex else {return nil}
            
            return pageList[nextIndex]
        }
        
        private func setupPageControl() {
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = .gray
            appearance.currentPageIndicatorTintColor = .red
            appearance.preferredIndicatorImage = UIImage.init(systemName: "heart.fill")
        }
        
        func presentationCount(for pageViewController: UIPageViewController) -> Int {
            setupPageControl()
            return pageList.count
        }

        func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            return currentIndex
        }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

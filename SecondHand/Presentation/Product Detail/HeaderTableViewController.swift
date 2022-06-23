//
//  HeaderTableViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 23/06/22.
//

import UIKit

class HeaderTableViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:320,height: 300))
        var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
        var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))

        override func viewDidLoad() {
            super.viewDidLoad()

            configurePageControl()

            scrollView.delegate = self
            scrollView.isPagingEnabled = true

            self.view.addSubview(scrollView)
            for index in 0..<4 {

                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                frame.size = self.scrollView.frame.size

                let subView = UIView(frame: frame)
                subView.backgroundColor = colors[index]
                self.scrollView .addSubview(subView)
            }

            self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)
            pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)

        }

        func configurePageControl() {
            // The total number of pages that are available is based on how many available colors we have.
            self.pageControl.numberOfPages = colors.count
            self.pageControl.currentPage = 0
            self.pageControl.tintColor = UIColor.red
            self.pageControl.pageIndicatorTintColor = UIColor.black
            self.pageControl.currentPageIndicatorTintColor = UIColor.green
            self.view.addSubview(pageControl)

        }

        // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
            let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
}

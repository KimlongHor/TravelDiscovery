//
//  RestaurantCarouselView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 9/8/21.
//

import SwiftUI
import Kingfisher

struct RestaurantCarouselView: UIViewControllerRepresentable {
    let imageUrlStrings: [String]
    let selectedIndex: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        let pvc = CarouselPageViewController(imageUrlStrings: imageUrlStrings, selectedIndex: selectedIndex)
        return pvc
    }
    
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CarouselPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var allControllers: [UIViewController] = []
    var selectedIndex: Int
    
    init(imageUrlStrings: [String], selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        allControllers = imageUrlStrings.map({ imageUrlString in
            let hostingController = UIHostingController(rootView:
                ZStack {
                    Color.black
                    KFImage(URL(string: imageUrlString))
                        .resizable()
                        .scaledToFit()
                }
            )
            
            hostingController.view.clipsToBounds = true
            
            return hostingController
        })
        if selectedIndex < allControllers.count {
            setViewControllers([allControllers[selectedIndex]], direction: .forward, animated: true, completion: nil)
        }
        
        // set color for the page indicator (or the dot below the page controller)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        
        self.dataSource = self
        self.delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else { return nil}
        if index == 0 { return nil }
        return allControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = allControllers.firstIndex(of: viewController) else { return nil }
        if index == allControllers.count - 1 { return nil }
        return allControllers[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return selectedIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RestaurantCarouselView_Previews: PreviewProvider {
    
    static let imageUrlStrings = [
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702"
    ]
    
    static var previews: some View {
        RestaurantCarouselView(imageUrlStrings: imageUrlStrings, selectedIndex: 1)
    }
}

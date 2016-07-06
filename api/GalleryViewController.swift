//
//  GalleryViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 8/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import UIKit

class GalleryViewController: BaseMenuViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIScrollView?] = []
    var originalScales:[Int : CGFloat] = [Int : CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        scrollView.delegate = self
        //pageImages = [UIImage(named:"alice-banner")!, UIImage(named:"alice-banner")!, UIImage(named:"alice-banner")!, UIImage(named:"alice-banner")!]
        startListeningToRotation()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.title = self.params?["title"] as? String
        getImages()
    }
    
    func getImages()
    {
        if let path = params?["path"] as? String
        {
            App.webapi.getJson(path, done:
            {
                if let imgPaths = $0.json as? [String]
                {
                    for imgPath in imgPaths
                    {
                        App.webapi.getImage(imgPath, useBaseUrl:false, done:
                        {
                            if let img = $0.image
                            {
                                self.pageImages.append(img)
                            }
                            if self.pageImages.count == imgPaths.count
                            {
                                self.setUp()
                            }
                        })
                    }
                }
            })
        }
    }
    
    func setUp()
    {
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageImages.count
        
        if pageViews.count == 0
        {
            for _ in 0 ..< pageImages.count
            {
                pageViews.append(nil)
            }
        }
        
        let scrollSize = scrollView.frame.size
        scrollView.contentSize  = CGSizeMake(scrollSize.width * CGFloat(pageImages.count), scrollSize.height)
        scrollView.tag = -1
        loadVisiblePages()
    }
    
    func purgePage(page: Int)
    {
        if page < 0 || page >= pageImages.count || page >= pageViews.count
        {
            return
        }
        
        if let pageView = pageViews[page]
        {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    
    func loadVisiblePages()
    {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        pageControl.currentPage = page
        
        let firstPage = page  - 1
        let lastPage = page + 1
        
        
        for index in 0.stride(to: firstPage, by: 1)
        {
            purgePage(index)
        }
        
        for index in firstPage ... lastPage
        {
            loadPage(index)
        }
        
        for index in (lastPage+1).stride(to: pageImages.count, by: 1)
        {
            purgePage(index)
        }
        
    }
    
    func resetZoom(page:Int)
    {
        if page < 0 || page >= pageViews.count
        {
            return
        }
        if let p = pageViews[page]
        {
            if let o = originalScales[page]
            {
                p.zoomScale = o
            }
        }
        
    }
    
    func loadPage(page: Int)
    {
        if page < 0 || page >= pageImages.count || page >= pageViews.count
        {
            return
        }
        
        if let _ = pageViews[page]
        {
            // ya está cargada la página, resetear zoom si no es la página actual
            if page != pageControl.currentPage
            {
                resetZoom(page)
            }
            return
        }
        
        var frame = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        
        let newScrollView = UIScrollView(frame: frame)
        let newPageView = UIImageView(image: pageImages[page])
        newPageView.contentMode = .ScaleAspectFit
        newPageView.frame = newScrollView.bounds
        newScrollView.addSubview(newPageView)
        
        
        newScrollView.minimumZoomScale = newScrollView.zoomScale
        if originalScales[page] == nil
        {
            originalScales[page] = newScrollView.zoomScale
        }
        newScrollView.maximumZoomScale = 2.2
        
        
        newScrollView.tag = page
        newScrollView.delegate = self
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 0.5;
        scrollView.addSubview(newScrollView)
        
        pageViews[page] = newScrollView
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        loadVisiblePages()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = scrollView.subviews.first!.frame
        
        if contentsFrame.size.width < boundsSize.width
        {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        }
        else
        {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height
        {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        }
        else
        {
            contentsFrame.origin.y = 0.0
        }
        
        let img = scrollView.subviews.first!
        img.frame = contentsFrame
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        if scrollView.tag == -1
        {
            return nil
        }
        else
        {
            return pageViews[scrollView.tag]!.subviews.first! as UIView
        }
    }
    
    override func rotated()
    {
        for i in 0 ..< pageViews.count
        {
            purgePage(i)
        }
        setUp()
    }

    
}

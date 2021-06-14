//
//  ViewController.swift
//  ejercicio_pageview
//
//  Created by Yaser  on 13/11/2020.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let pageTitles = ["Over 200 Tips and Tricks", "Discover Hidden Features", "Bookmark Favorite Tip", "Free Regular Update"];
    let pageImages = ["page1.png", "page2.png", "page3.png", "page4.png"];

    var pageViewController : UIPageViewController?
    
    @IBOutlet weak var startAgain: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controlado paginado
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController?
        self.pageViewController?.dataSource = self;
        self.pageViewController?.delegate = self;
        
        // Primer controlador de contenidol
        let startingViewController = self.viewControllerAtIndex(index: 0);
        let viewControllers = [startingViewController!];
        
        self.pageViewController?.setViewControllers(viewControllers, direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        // Tamaño para que quepa el botón
        self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-30)

        // Añadimos el primer controlador de contenido
        self.addChild(self.pageViewController!)
        self.view.addSubview((self.pageViewController?.view)!)
        self.pageViewController?.didMove(toParent: self)
    }

    @IBAction func restart(_ sender: AnyObject) {
        let startingViewController = self.viewControllerAtIndex(index: 0)
        let viewControllers = [startingViewController!]
        self.pageViewController?.setViewControllers(viewControllers, direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: nil)
    }
    
    func viewControllerAtIndex(index : Int) -> PageContentViewController? {
          if self.pageTitles.count == 0 || index >= self.pageTitles.count {
                  return nil;
          }

          // Crear un nuevo controlador de contenido y pasar los datos
          let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController

          pageContentViewController.imageFilename = self.pageImages[index];
          pageContentViewController.titleText = self.pageTitles[index];
          pageContentViewController.pageIndex = index;

          return pageContentViewController;
      }

      func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

          let pvc = viewController as! PageContentViewController
          var index = pvc.pageIndex;

          if index == 0 || index == Foundation.NSNotFound {
              return nil
          }

          index -= 1
          return self.viewControllerAtIndex(index: index)
      }

      func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

          let pvc = viewController as! PageContentViewController
          var index = pvc.pageIndex;

          if index == Foundation.NSNotFound {
              return nil
          }

          index += 1
          if index == self.pageTitles.count {
              return nil
          }
          return self.viewControllerAtIndex(index: index)
      }
    
    // Se indica a iOS el número de páginas (número de puntos) a mostrar
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    // Se indica cual es que tiene que empzar a mostrar
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
}


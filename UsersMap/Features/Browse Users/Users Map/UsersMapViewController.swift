//
//  UsersMapViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit
import MapKit
import Combine

/*
 Guide to use Mapbox

 - show map: https://docs.mapbox.com/ios/maps/guides/install/ below on the page
 - custom annotation view:
   - subclass of MGLPointAnnotation: https://docs.mapbox.com/ios/maps/examples/annotation-views/, https://stackoverflow.com/a/43524093 for clustering needs to use ClusterKit
   - maybe also MGLSymbolStyleLayer: https://docs.mapbox.com/ios/maps/examples/runtime-multiple-annotations/
 - clustering:
   - https://docs.mapbox.com/ios/maps/examples/clustering/
   - https://github.com/hulab/ClusterKit/

 */

final class UsersMapViewController: UIViewController {

    private(set) var viewModel: UsersListViewModel!

    @IBOutlet weak var mapView: MKMapView!

    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()

        mapView.delegate = self
        mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: "annotation")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$users
            .sink { [weak mapView] in
                guard let mapView = mapView else { return }

                let annotations = $0.map(UserAnnotation.init)
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(annotations)
                mapView.showAnnotations(mapView.annotations, animated: true)
            }
            .store(in: &cancellables)

        viewModel.$error
            .sink { [weak self] in
                if let error = $0, self?.isViewLoaded ?? false, self?.view.window != nil {
                    let alertController = UIAlertController(
                        title: NSLocalizedString("Error", comment: ""),
                        message: NSLocalizedString("Oops. An error happened:\n \(error.localizedDescription)", comment: ""),
                        preferredStyle: .alert)
                    alertController.addAction(
                        .init(
                            title: NSLocalizedString("Okay", comment: ""),
                            style: .cancel)
                    )
                    self?.present(alertController, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

extension UsersMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        return mapView.dequeueReusableAnnotationView(withIdentifier: "annotation", for: annotation)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? UserAnnotation else {
            return
        }
        viewModel.select(user: annotation.user)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
}

extension UsersMapViewController {
    class UserAnnotation: NSObject, MKAnnotation {
        let user: UsersListViewModel.UserInfo

        @objc dynamic var coordinate: CLLocationCoordinate2D {
            .init(latitude: user.location.latitude, longitude: user.location.longitude)
        }

        var title: String? { user.firstName }

        var imageURL: URL? { user.avatarImageURL }

        init(user: UsersListViewModel.UserInfo) {
            self.user = user
        }
    }
}

extension UsersMapViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: UsersListViewModel
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UsersMapViewController") as! Self
        viewController.viewModel = viewModel
        return viewController
    }
}

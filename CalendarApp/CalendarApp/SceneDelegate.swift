import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create and set the main view controller with navigation
        window = UIWindow(windowScene: windowScene)
        let calendarVC = CalendarVC() // Replace with your actual CalendarVC
        let navigationController = UINavigationController(rootViewController: calendarVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        // Call to show the Bottom Sheet
        showBottomSheet()
    }

    func showBottomSheet() {
        // Create the BottomSheetViewController
        let bottomSheetVC = BottomSheetViewController()

        // Set the modal presentation style to make it act like a bottom sheet
        bottomSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // Adjust the sheet size as you like
            sheet.prefersGrabberVisible = true
        }

        // Present the BottomSheet on top of the root view controller (which is a navigation controller)
        window?.rootViewController?.present(bottomSheetVC, animated: true, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}

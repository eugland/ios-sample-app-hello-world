import SwiftUI

@main
struct hello_worldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var services = AppServices.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services)
        }
    }
}

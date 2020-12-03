//
//  DeviceManagerHandler.swift
//  notificare
//
//  Created by Helder Pinhal on 01/12/2020.
//

import Foundation
import NotificareSDK

class DeviceManagerHandler {

    func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getCurrentDevice": getCurrentDevice(call, result)
        case "register": register(call, result)
        case "fetchTags": fetchTags(call, result)
        case "addTag": addTag(call, result)
        case "addTags": addTags(call, result)
        case "removeTag": removeTag(call, result)
        case "removeTags": removeTags(call, result)
        case "clearTags": clearTags(call, result)
        case "getPreferredLanguage": getPreferredLanguage(call, result)
        case "updatePreferredLanguage": updatePreferredLanguage(call, result)
        case "fetchDoNotDisturb": fetchDoNotDisturb(call, result)
        case "updateDoNotDisturb": updateDoNotDisturb(call, result)
        case "clearDoNotDisturb": clearDoNotDisturb(call, result)
        case "fetchUserData": fetchUserData(call, result)
        case "updateUserData": updateUserData(call, result)
        default: result(FlutterMethodNotImplemented)
        }
    }

    private func getCurrentDevice(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        response(Notificare.shared.deviceManager.currentDevice?.toDictionary())
    }

    private func register(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary

        Notificare.shared.deviceManager.register(
            userId: arguments["userId"] as? String,
            userName: arguments["userName"] as? String
        ) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchTags(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.deviceManager.fetchTags { result in
            switch result {
            case .success(let tags):
                response(tags)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func addTag(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let tag = call.arguments as! String

        Notificare.shared.deviceManager.addTag(tag) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func addTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let tags = call.arguments as! [String]

        Notificare.shared.deviceManager.addTags(tags) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func removeTag(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let tag = call.arguments as! String

        Notificare.shared.deviceManager.removeTag(tag) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func removeTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let tags = call.arguments as! [String]

        Notificare.shared.deviceManager.removeTags(tags) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func clearTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.clearTags { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func getPreferredLanguage(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        response(Notificare.shared.deviceManager.preferredLanguage)
    }

    private func updatePreferredLanguage(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let language = call.arguments as! String?

        Notificare.shared.deviceManager.updatePreferredLanguage(language) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.fetchDoNotDisturb { result in
            switch result {
            case .success(let dnd):
                response(dnd?.toDictionary())
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func updateDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary
        let dnd: NotificareDoNotDisturb

        do {
            dnd = try NotificareDoNotDisturb(dictionary: arguments)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }

        Notificare.shared.deviceManager.updateDoNotDisturb(dnd) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func clearDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.clearDoNotDisturb { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchUserData(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.fetchUserData { result in
            switch result {
            case .success(let userData):
                response(userData)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func updateUserData(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let userData = call.arguments as! [String: String]

        Notificare.shared.deviceManager.updateUserData(userData) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
}

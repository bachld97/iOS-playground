import UIKit


class TouchIgnoreView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden &&
                subview.alpha > 0 &&
                subview.isUserInteractionEnabled &&
                subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}

class LifecycleViewController: UIViewController {
    
    private var notiCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    var isTouchIgnoreViewController: Bool {
        return true
    }
    
    override func loadView() {
        if isTouchIgnoreViewController {
            self.view = TouchIgnoreView(frame: UIScreen.main.bounds)
        } else {
            super.loadView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerBackgroundForegroundNotification()
    }
    
    private func registerBackgroundForegroundNotification() {
        notiCenter.addObserver(
            self, selector: #selector(viewWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        notiCenter.addObserver(
            self, selector: #selector(viewDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        notiCenter.addObserver(
            self, selector: #selector(viewDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        notiCenter.addObserver(
            self, selector: #selector(viewWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
        let notiToRemove = [
            UIApplication.willEnterForegroundNotification,
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willResignActiveNotification,
            UIApplication.didBecomeActiveNotification
        ]
        
        notiToRemove.forEach { notiName in
            notiCenter.removeObserver(self, name: notiName, object: nil)
        }
    }
    
    
    @objc func viewDidEnterBackground() {
        
    }
    
    @objc func viewWillEnterForeground() {
        
    }
    
    @objc func viewWillResignActive() {
        removeKeyboardObserver()
    }
    
    @objc func viewDidBecomeActive() {
        addKeyboardObserver()
    }
    
    private func removeKeyboardObserver() {
        notiCenter.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        notiCenter.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    private func addKeyboardObserver() {
        notiCenter.addObserver(
            self, selector: #selector(keyboardObserver(noti:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        notiCenter.addObserver(
            self, selector: #selector(keyboardObserver(noti:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardObserver(noti: Notification) {
        guard noti.name == UIResponder.keyboardWillShowNotification ||
            noti.name == UIResponder.keyboardWillHideNotification else {
        
            return DebugMessage.notifyUnexpectedFlowOfControl()
        }
        
        let userInfo = noti.userInfo
        let animCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        let animDur = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        switch noti.name {
        case UIResponder.keyboardWillShowNotification:
            let beginFrame = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
            let endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect

            keyboardWillShow(
                keyboardBeginFrame: beginFrame,
                keyboardEndFrame: endFrame,
                animationCurve: animCurve,
                animationDuration: animDur
            )
            
        case UIResponder.keyboardWillHideNotification:
            keyboardWillHide(
                animationCurve: animCurve,
                animationDuration: animDur
            )
        default:
            break
        }
    }
    
    
    func keyboardWillShow(keyboardBeginFrame: CGRect,
                          keyboardEndFrame: CGRect,
                          animationCurve: UIView.AnimationCurve,
                          animationDuration: TimeInterval) {
        
    }
    
    func keyboardWillHide(animationCurve: UIView.AnimationCurve,
                          animationDuration: TimeInterval) {
        
    }
    
    private var lockRotationMask: UIInterfaceOrientationMask = .allButUpsideDown
    func rotate(to orientation: UIInterfaceOrientation, lockRotation mask: UIInterfaceOrientationMask) {
        let deviceOrientation: UIDeviceOrientation
        switch orientation {
            case .portrait:
                deviceOrientation = .portrait
            case .landscapeLeft:
                deviceOrientation = .landscapeLeft
            case .landscapeRight:
                deviceOrientation = .landscapeRight
            default:
                // In my application, I dont allow portraitUpsideDown
                deviceOrientation = .portrait
        }

        lockRotationMask = mask
        UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return lockRotationMask
    }
}

# Better base UIViewController

There are some repetitive functionality that almost every one of our `UIViewController` shares, as a result, it is beneficial to create a better base `UIViewController` to inherits from.

## Losing focus

It is never the case where the user use our application forever, without quitting or changing to another application. Our ViewControllers lose focus all the time, such as: when user pull the notification center / control center, user changes to another application, the user press home, or even a third party login request.

As a result, multiple viewcontrollers in our application share this same behavior, and let's us create a base class that offer this functionality. There are two types of losing focus: `resign/becomeActive` and `enterBackground/Foreground`. When our viewcontroller enters background, it also resigns active, and when it enters foreground, it also becomes active.

```swift
class LifecycleViewController: UIViewController {
    private var notiCenter: NotificationCenter {
        return NotificationCenter.default
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
}
```

## Keyboard observers

Keyboard show/hide events are also popular. As a result, I also decide to put it in here.

I will add/remove keyboard observers when our Viewcontroller `become/resignActive`

```swift
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
```

> We will also have to remove keyboard observers in `viewWillDisappear(animated:)` because when the viewcontroller is popped, `resignActive` is not called.

## Touch Ignore ViewController

I used ViewController composition quite often, as a result, I want user to be able to press through my viewcontroller where there are no subview.

As a result, I create an `UIView` subclass, and override `point(insde:with:)` function.

```swift
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
```

We then override `loadView()` and provide a way for subclass to decide if it will use touch ignore functionality.

```swift
class LifecycleViewController: UIViewController {
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
}
```

## Rotating

Force rotation is not as common as aforementioned functionality, but it is also useful, so let define a function for it.

At first, my implementation looks like this

```swift
private var lockRotationMask: UIInterfaceOrientationMask = .allButUpsideDown
func rotate(to orientation: UIInterfaceOrientation, 
            lockRotation mask: UIInterfaceOrientationMask
 ) {
  	lockRotationMask = mask
		UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
	return lockRotationMask
}
```

However, the `orientation` variable of `UIDevice` is not of type `UIInterfaceOrientation`, so using it as rawValue like I did produce wrong result (`landscapeLeft` and `landscapeRight` is inversed).

The more correct implementation would be as follow

```swift
func rotate(to orientation: UIInterfaceOrientation, 
            lockRotation mask: UIInterfaceOrientationMask
 ) {
  	
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
```

This looks good. However, when we leave our phone horizontally and issue a rotate to landscape, it will not work. This is because the device is already landscape, and setting `UIDeviceOrientation` once more to landscape will not do anything.

To force rotation, we have to add a call to `UIViewController.attemptRotationToDeviceOrientation()` at the bottom of our function.

Now it should work as expected.

> In cases where orientation logic is more complex, just override `supportedInterfaceOrientations`.
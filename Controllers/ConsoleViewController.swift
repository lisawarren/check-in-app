import UIKit
import CoreBluetooth

class ConsoleViewController: UIViewController {

  //Bluefruit data
  var peripheralManager: CBPeripheralManager?
  var peripheral: CBPeripheral?
  var periperalTXCharacteristic: CBCharacteristic?

  @IBOutlet weak var consoleTextView: UITextView!
  @IBOutlet weak var consoleTextField: UITextField!


  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
  override func viewDidLoad() {
      super.viewDidLoad()

    keyboardNotifications()

    NotificationCenter.default.addObserver(self, selector: #selector(self.appendRxDataToTextView(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)

    consoleTextField.delegate = self
  }
 
// printing out the data from rx characteristic on bluefruit onto the textfield in the app
  @objc func appendRxDataToTextView(notification: Notification) -> Void{
    consoleTextView.text.append("\n[Recieved]: \(notification.object!) \n")
  }

// printing out the data we wrote to the bluefruit on the textfield in the app
  func appendTxDataToTextView(){
    consoleTextView.text.append("\n[Sent]: \(String(consoleTextField.text!)) \n")
  }

  func keyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  // MARK:- Keyboard
  @objc func keyboardWillChange(notification: Notification) {

    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      let keyboardHeight = keyboardSize.height
      print(keyboardHeight)
      view.frame.origin.y = (-keyboardHeight + 50)
    }
  }

  @objc func keyboardDidHide(notification: Notification) {
    view.frame.origin.y = 0
  }

  @objc func disconnectPeripheral() {
    print("Disconnect for peripheral.")
  }

  // Writing input to the tx characteristic
  func writeOutgoingValue(data: String){
      let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
      //change the "data" to valueString
    if let blePeripheral = BlePeripheral.connectedPeripheral {
          if let txCharacteristic = BlePeripheral.connectedTXChar {
              blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
          }
      }
  }

  func writeCharacteristic(incomingValue: Int8){
    var val = incomingValue

    let outgoingData = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
    peripheral?.writeValue(outgoingData as Data, for: BlePeripheral.connectedTXChar!, type: CBCharacteristicWriteType.withResponse)
  }
}

extension ConsoleViewController: CBPeripheralManagerDelegate {

  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    switch peripheral.state {
    case .poweredOn:
        print("Peripheral Is Powered On.")
    case .unsupported:
        print("Peripheral Is Unsupported.")
    case .unauthorized:
    print("Peripheral Is Unauthorized.")
    case .unknown:
        print("Peripheral Unknown")
    case .resetting:
        print("Peripheral Resetting")
    case .poweredOff:
      print("Peripheral Is Powered Off.")
    @unknown default:
      print("Error")
    }
  }


  //Check when a device subscribes to our characteristic, start sending the data
  func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
      print("Device subscribe to characteristic")
  }

}

extension ConsoleViewController: UITextViewDelegate {

}

extension ConsoleViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    writeOutgoingValue(data: textField.text ?? "")
    appendTxDataToTextView()
    textField.resignFirstResponder()
    textField.text = ""
    return true

  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    textField.clearsOnBeginEditing = true
    return true
  }

}

//
//  ViewController.swift
//  d00
//
//  Created by Claudio MUTTI on 10/1/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private enum Operations : Int {
        case None = 0
        case Add
        case Sub
        case Mul
        case Div
        case Equals
    }
    
    // Constants
    private let overflowMessage = "Overflow";

    // Variables
    private var hasOverflow : Bool = false;
    private var needNumericInput : Bool = true;
    private var myTot : Int = 0;
    private var tmpValue : Int = 0;
    private var savedOperation : Operations = Operations.None;

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonReset(_ sender: UIButton) {
        hasOverflow = false;
        needNumericInput = true;
        myTot = 0;
        tmpValue = 0;
        savedOperation = Operations.None;
        resultLabel.text = "0";
        print("Reset");
    }
    
    @IBAction func buttonZero(_ sender: UIButton) {
        addToTmp(toAdd: 0);
    }
    @IBAction func buttonOne(_ sender: UIButton) {
        addToTmp(toAdd: 1);
    }
    @IBAction func buttonTwo(_ sender: UIButton) {
        addToTmp(toAdd: 2);
    }
    @IBAction func buttonThree(_ sender: UIButton) {
        addToTmp(toAdd: 3);
    }
    @IBAction func buttonFour(_ sender: UIButton) {
        addToTmp(toAdd: 4);
    }
    @IBAction func buttonFive(_ sender: UIButton) {
        addToTmp(toAdd: 5);
    }
    @IBAction func buttonSix(_ sender: UIButton) {
        addToTmp(toAdd: 6);
    }
    @IBAction func buttonSeven(_ sender: UIButton) {
        addToTmp(toAdd: 7);
    }
    @IBAction func buttonEight(_ sender: UIButton) {
        addToTmp(toAdd: 8);
    }
    @IBAction func buttonNine(_ sender: UIButton) {
        addToTmp(toAdd: 9);
    }
    
    private func addToTmp(toAdd: Int) {
        // Log
        print("Button '" + String(toAdd) + "' pressed");
        
        // Check
        if (hasOverflow) {
            return;
        }

        // Implicit start of new calculation
        if (savedOperation == Operations.Equals) {
            myTot = 0;
            savedOperation = Operations.Add;
        }

        // Increase tmpValue
        (tmpValue, hasOverflow) = tmpValue.multipliedReportingOverflow(by: 10);
        if (!hasOverflow) {
            (tmpValue, hasOverflow) = tmpValue.addingReportingOverflow(tmpValue >= 0 ? toAdd : -toAdd);
        }

        resultLabel.text = (!hasOverflow) ? String(tmpValue) : overflowMessage;
        needNumericInput = false;
    }
    
    @IBAction func buttonAdd(_ sender: UIButton) {
        changeOperation(newOperation: Operations.Add);
    }
    @IBAction func buttonSub(_ sender: UIButton) {
        changeOperation(newOperation: Operations.Sub);
    }
    @IBAction func buttonDiv(_ sender: UIButton) {
        changeOperation(newOperation: Operations.Div);
    }
    @IBAction func buttonMul(_ sender: UIButton) {
        changeOperation(newOperation: Operations.Mul);
    }
    @IBAction func buttonEquals(_ sender: UIButton) {
        changeOperation(newOperation: Operations.Equals);
    }
    
    private func changeOperation(newOperation: Operations) {
        // Log
        if (newOperation != Operations.Equals) {
            print("Saving " + String(describing: newOperation) + " operation");
        }
        else {
            print("Doing " + String(describing: newOperation) + " operation");
        }

        // Check
        if (hasOverflow || needNumericInput) {
            return;
        }

        // Resolve past operation
        switch (savedOperation) {
            case .Add:
                (myTot, hasOverflow) = myTot.addingReportingOverflow(tmpValue);
                break;
            case .Sub:
                (myTot, hasOverflow) = myTot.subtractingReportingOverflow(tmpValue);
                break;
            case .Div:
                if (tmpValue != 0) {
                    (myTot, hasOverflow) = myTot.dividedReportingOverflow(by: tmpValue);
                }
                break;
            case .Mul:
                (myTot, hasOverflow) = myTot.multipliedReportingOverflow(by: tmpValue);
                break;
            case .None:
                myTot = tmpValue;
                break;
            default:
                break;
        }

        // Save new operation
        savedOperation = newOperation;
        tmpValue = 0;

        // Print result
        resultLabel.text = (!hasOverflow) ? String(myTot) : overflowMessage;

        // Protect against spam of operation
        if (savedOperation != Operations.Equals) {
            needNumericInput = true;
        }
    }

    @IBAction func negButton(_ sender: UIButton) {
        // Log
        print("Button 'Neg' pressed");
        
        // Check
        if (hasOverflow || needNumericInput) {
            return;
        }
        
        if (savedOperation == Operations.Equals) {
            (myTot, hasOverflow) = myTot.multipliedReportingOverflow(by: -1);
            resultLabel.text = (!hasOverflow) ? String(myTot) : overflowMessage;
        }
        else {
            (tmpValue, hasOverflow) = tmpValue.multipliedReportingOverflow(by: -1);
            resultLabel.text = (!hasOverflow) ? String(tmpValue) : overflowMessage;
        }
    }
}


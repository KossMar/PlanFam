//
//  AddSteppingStoneViewController.swift
//  GoalsTimelineApp
//
//  Created by Carlo Namoca on 2017-10-31.
//  Copyright © 2017 Carlo Namoca. All rights reserved.
//

import UIKit
import CoreData

protocol SteppingStoneDelegate {
    func addSteppingStone()
}

class AddSteppingStoneViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var steppingStoneTitle: UITextField!
    @IBOutlet weak var steppingStoneNotes: UITextView!
    @IBOutlet weak var steppingStoneDueDatePicker: UIDatePicker!
    var timelineObject : Timeline = Timeline ()
    var delegate : SteppingStoneDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "New Stepping Stone"
        self.setupTextfieldsView()
        self.setupDatePicker()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addSteppingStoneClicked(_ sender: UIButton) {
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer : NSPersistentContainer = appDelegate.persistentContainer
        
        let newSteppingStone : SteppingStone = SteppingStone(context: persistentContainer.viewContext)
        newSteppingStone.title = steppingStoneTitle.text
        newSteppingStone.info = steppingStoneNotes.text
        newSteppingStone.deadline = steppingStoneDueDatePicker.date as NSDate
        newSteppingStone.isCompleted = false
        
        let dateDifference : TimeInterval = (newSteppingStone.deadline?.timeIntervalSince(timelineObject.startDate! as Date))!
        let intDate = Int(dateDifference)/86400
        
        newSteppingStone.dateIndex = Int16(intDate)
        
        timelineObject.addToSteppingStones(newSteppingStone)
        
        
        appDelegate.saveContext()
        
        
        self.dismiss(animated: true, completion: nil)
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
    
    
    // MARK: - Text Fields setup
    
    //Set up "fake" placeholder in Note textView
    func setupTextfieldsView() {
        steppingStoneNotes.delegate = self
        steppingStoneNotes.textColor = UIColor.lightGray
        steppingStoneNotes.text = "Notes"
        
        
    }
    
    //Remove "fake" placeholder when uset taps on textview
    func textViewDidBeginEditing(_ steppingStoneNotes: UITextView) {
        if steppingStoneNotes.text == "Notes"
        {
            steppingStoneNotes.text = ""
            steppingStoneNotes.textColor = UIColor.black
        }
        steppingStoneNotes.becomeFirstResponder()
    }
    
    //Show "fake" placeholder if user entered nothing
    func textViewDidEndEditing(_ steppingStoneNotes: UITextView)
    {
        if (steppingStoneNotes.text == "")
        {
            steppingStoneNotes.text = "Notes"
            steppingStoneNotes.textColor = .lightGray
        }
        steppingStoneNotes.resignFirstResponder()
    }
    
    // MARK: - Datepickers setup
    
    //Set start daypicker default value to today, don't let select date in the past
    func setupDatePicker() {
        steppingStoneDueDatePicker.minimumDate = NSDate() as Date
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

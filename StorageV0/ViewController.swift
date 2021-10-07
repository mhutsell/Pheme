//
//  ViewController.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	let tableView: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
		return table
	} ()
	
	private var models = [NaiveMessage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		title = "Messages stored"
		view.addSubview(tableView)
		getAllMessages()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.frame=view.bounds
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
	}
	
	@objc private func didTapAdd() {
		let alert = UIAlertController(title: "New message",message:"Enter new message",preferredStyle: .alert)
		alert.addTextField(configurationHandler: nil)
		alert.addAction(UIAlertAction(title:"Submit", style: .cancel, handler: {[weak self] _ in
			guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
				return
			}
			self!.createMessage(ms: text)
		}))
		present(alert, animated: true)
	}
//
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = models[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = message.messageBody
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let ms = models[indexPath.row]
		let sheet = UIAlertController(title: "Edit",message:nil,preferredStyle: .actionSheet)
		sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
			self?.deleteMessage(ms: ms)
		}))
		present(sheet, animated: true)
	}

	// test messages with Core data MOST NAIVE
	func getAllMessages() {
		do {
			models = try context.fetch(NaiveMessage.fetchRequest())
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		} catch {
			// error
		}
	}
	
	func createMessage(ms: String) {
		let newMessage = NaiveMessage(context: context)
		newMessage.messageBody = ms
		newMessage.timeCreated = Date()
		newMessage.identifier = UUID()
		
		do {
			try context.save()
			getAllMessages()
		} catch {
			// error
		}
	}
    
    func createIdentity(ms: String, password: Int64, id: Int64){
        let newIdentity = Identity(context: context)
        newIdentity.nickname = ms
        newIdentity.password = password
        newIdentity.id = id
        
        do {
            try context.save()
            getAllMessages()
        } catch {
            // error
        }
    }
    
    @objc private func inputIdentity() {
        let alert = UIAlertController(title: "New User Sign-up",message:"Enter new username",preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title:"Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let nickname = field.text, !text.isEmpty else {
                return
            }
            guard let field = alert.textFields?.second, let password = field.text, !text.isEmpty else {
                return
            }
            guard let field = alert.textFields?.second, let id = field.text, !text.isEmpty else {
                return
            }
            self!.createIdentity(ms: nickname, password, id)
        }))
        present(alert, animated: true)
    }
    
	func deleteMessage(ms: NaiveMessage){
		context.delete(ms)
		
		do {
			try context.save()
			getAllMessages()
		} catch {
			// error
		}
	}

}


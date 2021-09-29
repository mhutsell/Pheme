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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = models[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = message.messageBody
		return cell
	}


	// test messages with Core data MOSTNAIVE
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
	
	func deleteMessage(ms: NaiveMessage){
		context.delete(ms)
		
		do {
			try context.save()
		} catch {
			// error
		}
	}

}


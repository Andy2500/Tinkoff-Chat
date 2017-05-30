//
//  ConversationDataProvider.swift
//  Tinkoff Chat
//
//  Created by Андрей on 14.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit
import CoreData

class ConversationDataProvider: NSObject {
    var fetchedResultsController: NSFetchedResultsController<Message>
    var tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        
        fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        fetchedResultsController.delegate = self
    }
}

extension ConversationDataProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controllerWillChangeContent:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange  anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
        case .move, .update: break
        }
    }
    
}


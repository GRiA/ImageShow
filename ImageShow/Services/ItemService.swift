//
//  ItemService.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import Foundation

protocol ItemServiceDelegate: AnyObject {
	func update()
	func check()
}

final class ItemService {
	static let shared = ItemService()
	private(set) var items: [CellType] = []
	
	private var downloadTask: Task<(), Never>?
	private var delegates: [any ItemServiceDelegate] = []
	
	func stop() {
		downloadTask?.cancel()
		downloadTask = nil
	}
	
	func start() {
		downloadTask = Task {
			do {
				let itemListUrl = try await downloadSourceFile()
				print("Item list: \(itemListUrl)")
				let items = try await parseItemList(itemListUrl)
				await updateItems(with: items)
				
			} catch {
				print("Error: \(error)")
			}
		}
		startNetworkTracking()
	}
	
	func addDelegate(_ delegate: any ItemServiceDelegate) {
		delegates.append(delegate)
	}
	
	func removeDelegate(_ delegate: any ItemServiceDelegate) {
		delegates.removeAll { $0 === delegate }
	}
}

private extension ItemService {
	func downloadSourceFile(_ url : URL = .sourceFileUrl) async throws -> URL {
		let (tmpUrl, response) = try await URLSession.shared.download(from: url)
		guard
			(response as? HTTPURLResponse)?.statusCode == 200
		else {
			throw URLError(.badServerResponse)
		}
		return try FileManager.default.moveToCache(fileURL: tmpUrl, with: "itemlist.txt")
	}
	
	func parseItemList(_ fileUrl: URL) async throws -> [CellType] {
		let linkDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
		var cells: [CellType] = []
		for try await line in fileUrl.lines {
			print("Line: \(line)")
			let matches = linkDetector.matches(in: line, range: NSRange(location: 0, length: line.count))
			guard
				!matches.isEmpty
			else {
				cells.append(.unknown(line))
				continue
			}
			for match in matches {
				guard
					let range = Range(match.range, in: line),
					let url = URL(string: String(line[range]))
				else {
					continue
				}								
				cells.append(.image(url))
			}
		}
		return cells
	}
	
	func updateItems(with newItems: [CellType]) async {
		let diff = newItems.difference(from: items)
		items = items.applying(diff) ?? []
		for delegate in self.delegates {
			delegate.update()
		}
	}
	
	func startNetworkTracking() {
		Task {
			for await isConnected in NetworkMonitor.shared.networkStatus {
				await MainActor.run {
					if isConnected {
						for delegate in self.delegates {
							delegate.check()
						}
					}
				}
			}
		}
	}
}

private extension URL {
	nonisolated static let sourceFileUrl: URL = URL(string: "https://it-link.ru/test/images.txt")!
}

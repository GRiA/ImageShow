//
//  NetworkMonitor.swift
//  ImageShow
//
//  Created by Anton Grishin on 15.04.2026.
//

import Network

class NetworkMonitor {
	static let shared = NetworkMonitor()
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitorQueue")
	
	var networkStatus: AsyncStream<Bool> {
		AsyncStream { continuation in
			monitor.pathUpdateHandler = { path in
				continuation.yield(path.status == .satisfied)
			}
			
			continuation.onTermination = { [weak self] _ in
				self?.monitor.cancel()
			}
			
			monitor.start(queue: queue)
		}
	}
}

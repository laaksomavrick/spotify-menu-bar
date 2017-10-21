//
//  MenuButtonView.swift
//  Spotify Helper
//
//  Created by Mavrick Laakso on 2017-10-21.
//  Copyright © Mavrick Laakso. All rights reserved.
//

import Cocoa

class SpotifyMenuButton {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let popover = NSPopover()
    var eventListener: EventListener?
}

extension SpotifyMenuButton {
    
    //MARK: - view initialization related functions (data bindings / view init)
    
    func set() {
        setTitle()
        setPopover()
        setEventListener()
    }
    
    func setTitle() {
        if let button = statusItem.button {
            button.title = "test"
            button.action = #selector(self.togglePopover(_:))
            button.target = self
        }
    }
    
    func setPopover() {
        popover.contentViewController = SpotifyPlayerViewController.freshController()
    }
    
    func setEventListener() {
        eventListener = EventListener(mask : [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let this = self, this.popover.isShown {
                this.closePopover(sender: event)
            }
        }
    }
    
}

extension SpotifyMenuButton {
    
    //MARK: - view action related functions (controller)

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventListener?.start()
            
            print("here")
            Spotify.conn.currentlyPlaying()
            
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventListener?.stop()
    }
    
}

import Foundation
import MultipeerConnectivity

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String)
}

protocol Communicator {
    func sendMessage(string: String, to userID: String, complectionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate?{get set}
    var online: Bool{get set}
}

class MultipeerCommunicator : NSObject, MCNearbyServiceBrowserDelegate,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate, Communicator {
    
    let serviceType = "tinkoff-chat"
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    let discoveryInfo = ["userName":"alex.iphone"]
    weak var delegate: CommunicatorDelegate?
    var online: Bool = true
    
    var sessions:[MCSession] = []
    var onlinePeers:[MCPeerID] = []
    static var communicator: MultipeerCommunicator?
    
    static func getCommunicator()->MultipeerCommunicator{
        if communicator != nil{
            return communicator!
        }else {
            communicator = MultipeerCommunicator()
            return communicator!
        }
    }
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: discoveryInfo, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, complectionHandler: ((_ success: Bool, _ error: Error?) -> ())?){
        do {
            let dicionary = ["eventType":"Text Message", "messageId":generateMessageID(), "text": string]
            let data = try JSONSerialization.data(withJSONObject: dicionary, options: [] )
            
            if let session = self.sessions.first(where: {$0.connectedPeers.contains(where: {$0.displayName == userID} )} ){
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                complectionHandler?(true, nil)
            } else {
                complectionHandler?(false, nil)
            }
        }
        catch let error {
            complectionHandler?(false, error)
        }
    }
    
    func generateMessageID()->String{
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        if !self.onlinePeers.contains(peerID){
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            sessions.append(session)
            onlinePeers.append(peerID)
            print("invitePeer: \(peerID)")
            
            do{
                let data = try JSONSerialization.data(withJSONObject: discoveryInfo, options: [] )
                browser.invitePeer(peerID, to: session, withContext: data, timeout: 30)
                delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"]!)
            } catch {
                
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        
        //if self.sessions.contains(where: {$0.connectedPeers.contains(peerID)} ){
        if self.onlinePeers.contains(peerID){
            invitationHandler(false, nil)
        } else {
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            sessions.append(session)
            onlinePeers.append(peerID)
            invitationHandler(true, session)
            
            do {
                if let json = try JSONSerialization.jsonObject(with: context!, options: []) as? Dictionary<String, String>{
                    delegate?.didFoundUser(userID: peerID.displayName, userName: json["userName"]!)
                }
            } catch {
                invitationHandler(false, nil)
            }
            
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.rawValue)")
        switch (state) {
        case MCSessionState.connected:
            print("Connected: \(peerID)");
            print(session)
            break;
        case MCSessionState.connecting:
            print("Connecting: \(peerID)");
            break;
        case MCSessionState.notConnected:
            sessions.remove(at: sessions.index(of: session)!)
            onlinePeers.remove(at: onlinePeers.index(of: peerID)!)
            delegate?.didLostUser(userID: peerID.displayName)
            print("Not Connected: \(peerID)");
            break;
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
            print(dictionary)
            delegate?.didRecieveMessage(text: dictionary["text"]!, fromUser: peerID.displayName, toUser: self.myPeerId.displayName)
        } catch {
            print(error)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
}


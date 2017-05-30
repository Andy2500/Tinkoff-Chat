import Foundation
import MultipeerConnectivity

class MultipeerCommunicator : NSObject, MCNearbyServiceBrowserDelegate,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate, ICommunicator {
    
    let serviceType = "tinkoff-chat"
    let myPeerId = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    let discoveryInfo = ["userName":"alex.iphone"]
    weak var delegate: CommunicatorDelegate?
    var online: Bool = true
    
    var sessions:[MCSession] = []
    var onlinePeers:[MCPeerID: String] = [:]
    
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
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if self.onlinePeers[peerID] != nil{
        } else {
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            sessions.append(session)
            
            print("invitePeer: \(peerID)")
            do{
                let data = try JSONSerialization.data(withJSONObject: discoveryInfo, options: [] )
                browser.invitePeer(peerID, to: session, withContext: data, timeout: 100)
                if let userName = info?["userName"]{
                    onlinePeers[peerID] = userName
                }
            } catch {
                
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        
        if self.onlinePeers[peerID] != nil{
            invitationHandler(false, nil)
        } else {
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            sessions.append(session)
            
            invitationHandler(true, session)
            
            do {
                if let context = context, let json = try JSONSerialization.jsonObject(with: context, options: []) as? Dictionary<String, String>,
                    let userName = json["userName"]{
                    delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
                    onlinePeers[peerID] = userName
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
            delegate?.didFoundUser(userID: peerID.displayName, userName: "")
        case MCSessionState.connecting:
            print("Connecting: \(peerID)");
        case MCSessionState.notConnected:
            sessions.remove(at: sessions.index(of: session)!)
            onlinePeers.removeValue(forKey: peerID)
            delegate?.didLostUser(userID: peerID.displayName)
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
    
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        
    }
    
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?){
        
    }
}


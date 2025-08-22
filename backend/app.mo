import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Array "mo:base/Array";

actor Chat {
  // Message type: only ciphertext
  public type Message = {
    from: Principal;
    to: Principal;
    timestamp: Time.Time;
    algo: Text;
    nonce: Text;
    ciphertext: Text;
  };

  // Store all messages here (stable to survive upgrades)
  stable var messages: [Message] = [];

  // Send an encrypted message
  public shared ({caller}) func sendEncrypted(
    to: Principal,
    algo: Text,
    nonce: Text,
    ciphertext: Text
  ) : async Text {
    let msg: Message = {
      from = caller;
      to = to;
      timestamp = Time.now();
      algo = algo;
      nonce = nonce;
      ciphertext = ciphertext;
    };
    messages := Array.append(messages, [msg]);
    return "Message sent (encrypted)";
  };

  // List inbox: all encrypted messages sent to me
  public shared ({caller}) func listInbox() : async [Message] {
    return Array.filter<Message>(messages, func (msg) {
      msg.to == caller
    });
  };

  // List sent: all encrypted messages sent by me
  public shared ({caller}) func listSent() : async [Message] {
    return Array.filter<Message>(messages, func (msg) {
      msg.from == caller
    });
  };

  // Return your principal as text
  public shared query ({caller}) func whoami() : async Text {
    Principal.toText(caller)
  };
}

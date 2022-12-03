// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../EPNS/IPUSHCommInterface.sol";
abstract contract EPNSSendNotification {

    address public  epnsCommAddress;
    address public  epnsChannel;
    bool sendNotifications;


    constructor(address _epnsCommAddress, address _epnsChannel, bool _sendNotifications) 
    {
        epnsCommAddress = _epnsCommAddress;
        epnsChannel = _epnsChannel;
        sendNotifications = _sendNotifications;
    }

    function push(address receipient) internal {
        if(!sendNotifications) return ;
        IPUSHCommInterface(epnsCommAddress).sendNotification(
            epnsChannel, // from channel
            receipient, // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
            bytes(
                string(
                    // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                    abi.encodePacked(
                        "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                        "+", // segregator
                        "3", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                        "+", // segregator
                        "Tranfer Alert", // this is notificaiton title
                        "+", // segregator
                        "GM! ", // notification body
                        "Your NFT on destination is ready" // notification body
                    )
                )
            )
        );
    }
}
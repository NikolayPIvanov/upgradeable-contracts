// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address deployed = DevOpsTools.get_most_recent_deployment("ERC1967", block.chainid);

        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();

        address proxy = upgradeBox(deployed, address(boxV2));

        return proxy;
    }

    function upgradeBox(address proxy, address implementation) public returns (address) {
        vm.startBroadcast();
        UUPSUpgradeable previousBox = UUPSUpgradeable(proxy);

        previousBox.upgradeToAndCall(implementation, "");

        vm.stopBroadcast();

        return proxy;
    }
}

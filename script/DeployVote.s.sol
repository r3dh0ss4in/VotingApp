// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployVoting is Script {
    function run() external returns (Voting, HelperConfig) {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the HelperConfig contract to get the network configuration
        HelperConfig helperConfig = new HelperConfig();
        //address admin = helperConfig.getAdmin();

        // Define the initial candidate names
        string[] memory candidateNames = new string[](3);
        candidateNames[0] = "Candidate A";
        candidateNames[1] = "Candidate B";
        candidateNames[2] = "Candidate C";

        // Deploy the Voting contract with the initial candidate names
        Voting voting = new Voting(candidateNames);

        // Optionally, transfer admin rights if needed
        // This step is only necessary if you want to change the admin after deployment
        // For example, if the Voting contract allows transferring admin rights
        // voting.transferAdmin(admin);

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Return the deployed Voting contract and HelperConfig for further use
        return (voting, helperConfig);
    }
}

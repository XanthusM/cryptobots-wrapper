// SPDX-License-Identifier: NONE
pragma solidity 0.8.6;

import '@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol';


contract MockNFT is ERC721PresetMinterPauserAutoId {
    constructor() ERC721PresetMinterPauserAutoId("MockNFT", "MockNFT", "") {

    }
}
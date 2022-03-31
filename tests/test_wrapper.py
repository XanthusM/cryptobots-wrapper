from brownie import *
from brownie import reverts
from web3.constants import *


def test_wrapper_setBaseURI(wrapper, admin):
    tx = wrapper.setBaseURI('qwer1', {"from": admin})
    uriset = tx.events['BaseURISet']
    assert uriset['value'] == 'qwer1'


def test_wrapper_setContractURI(wrapper, admin):
    tx = wrapper.setContractURI('wrap1', {"from": admin})
    contrset = tx.events['ContractURISet']
    assert contrset['value'] == 'wrap1'


def test_nonexistent_tokenURI(wrapper, admin):
    with reverts('ERC721Metadata: URI query for nonexistent token'):
        tx = wrapper.tokenURI(1, {"from": admin})


def test_tokenURI(nft, wrapper, admin):
    tx = nft.mint(admin, {"from": admin})
    token_id0 = tx.events['Transfer']['tokenId']
    assert token_id0['tokenId'] == 0
    token0 = token_id0['tokenId']
    tx = wrapper.tokenURI(token0, {"from": admin})


def test_incorrect_owner(wrapper, admin, users):
    with reverts('ERC721: owner query for nonexistent token'):
        tx = wrapper.unwrap(1, {"from": users[1]})


def test_wrap(wrapper, nft, admin):
    tx = nft.mint(admin, {"from": admin})
    token_id0 = tx.events['Transfer']['tokenId']
    assert token_id0['tokenId'] == 0
    token0 = token_id0['tokenId']
    tx = wrapper.wrap(0, {"from": admin})


def test_botcore(botcore, admin):
    tx = botcore.getBot(1, {"from": admin})
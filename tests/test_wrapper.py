from brownie import *
from brownie import reverts
from web3.constants import *


def wrapper_setBaseURI(wrapper, admin):
    tx = wrapper.setBaseURI(rewq, {"from": admin})
    assert tx.events['BaseURISet']== rewq


def wrapper_setContractURI(wrapper, admin):
    tx = wrapper.setContractURI(wrap1, {"from": admin})
    assert tx.events['ContractURISet']== wrap1

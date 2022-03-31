from brownie import *
import pytest


@pytest.fixture
def admin(accounts):
    return accounts[0]


@pytest.fixture
def users(accounts):
    return accounts[1:]


@pytest.fixture
def user0(users):
    return users[0]


@pytest.fixture
def user1(users):
    return users[1]
    
@pytest.fixture
def botCoreAddr(users):
    return users[2]    


@pytest.fixture()
def qwer():
    return qwer


@pytest.fixture()
def wrap():
    return wrap


@pytest.fixture
def wrapper(admin, users):
    contract = NFTWrapper.deploy(users[2], qwer, wrap, {"from": admin})
    return contract


@pytest.fixture
def botcore(admin, users):
    contract = BotCore.deploy({"from": admin})
    return contract


@pytest.fixture
def nft(admin):
    contract = MockNFT.deploy({'from': admin})
    return contract

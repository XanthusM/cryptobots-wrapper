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
def user2(users):
    return users[2]    


@pytest.fixture
def wrapper(admin):
    contract = NFTWrapper.deploy(0xd4Bb17B32493FFFe424f9Cc9aA1b7E2aB589AA3b, qwer, wrap, {"from": admin})
    return contract

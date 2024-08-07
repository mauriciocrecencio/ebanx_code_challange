# test/controllers/events_controller_test.rb
require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should reset state" do
    post reset_url
    assert_equal 0, Account.count
    assert_response :success
  end

  test "should get balance for non-existing account" do
    get balance_url, params: { account_id: '1234' }
    assert_response :not_found
  end

  test "should create account with initial balance" do
    post event_url, params: { type: 'deposit', destination: '100', amount: 10 }
    assert_response :created
    assert_equal({ "destination" => { "id" =>  100, "balance" => 10 } }, JSON.parse(response.body))
  end

  test "should deposit into existing account" do
    Account.create(id: '100', balance: 10)
    post event_url, params: { type: 'deposit', destination: '100', amount: 10 }
    assert_response :created
    assert_equal({ "destination" => { "id" => 100, "balance" => 20 } }, JSON.parse(response.body))
  end

  test "should get balance for existing account" do
    Account.create(id: 100, balance: 20)
    get balance_url, params: { account_id: '100' }
    assert_response :success
    assert_equal 20, JSON.parse(response.body)
  end

  test "should withdraw from non-existing account" do
    post event_url, params: { type: 'withdraw', origin: '200', amount: 10 }
    assert_response :not_found
  end

  test "should withdraw from existing account" do
    Account.create(id: 100, balance: 20)
    post event_url, params: { type: 'withdraw', origin: '100', amount: 5 }
    assert_response :created
    assert_equal({ "origin" => { "id" => 100, "balance" => 15 } }, JSON.parse(response.body))
  end

  test "should transfer from existing account" do
    Account.create(id: '100', balance: 20)
    post event_url, params: { type: 'transfer', origin: '100', amount: 15, destination: '300' }
    assert_response :created
    assert_equal({ "origin" => { "id" => 100, "balance" => 5 }, "destination" => { "id" => 300, "balance" => 15 } }, JSON.parse(response.body))
  end

  test "should transfer from non-existing account" do
    post event_url, params: { type: 'transfer', origin: '200', amount: 15, destination: '300' }
    assert_response :not_found
  end
end

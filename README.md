# Homework4-F19
Raghav Sreeram
9151634498 


The 4th update to the app included the following things: 
- Account View Controller for controlling each account
- When an account is selected from the table view, the account view controller is called with that account
- Allows user to Deposit, Withdraw, Transfer and delete accounts
- User can also add a new account
-All changes are done through the API 


The Custom Pop ups for Deposit, Withdraw, Transfer and delete are done through hiding and showing respective Views.
The custom pop up for Adding account, however, is done by presenting a different view controller using the over current context option. I used a protocol delegate method to pass data between the view controllers



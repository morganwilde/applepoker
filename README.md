#README

![First](https://raw.githubusercontent.com/morganwilde/applepoker/master/documentation/doc-one.png)

## API

### URL list

1. `/user/count`
2. `/user/<username>/add`
3. `/user/<identifier>/info/<attribute>`
4. `/user/<identifier>/remove`

### URL responses



```Python

@app.route('/user/<username>/add')
def returnUserAdd(username):
    """
    Adds user to user list
    Return user ID in that list
    """
    if len(username) > 0:
        if not User.checkIfUserWithNameExists(username):
            user = User(username)
            return str(user.getUserID())
        else:
            return 'error: user with that name exists!'
    else:
        return 'error: username cannot be empty!'
```
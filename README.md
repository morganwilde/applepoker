#README

![First](https://raw.githubusercontent.com/morganwilde/applepoker/master/documentation/doc-one.png)

## API

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
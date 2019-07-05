import os
from flask import Flask
from praw import Reddit
 
app = Flask(__name__)
reddit_conf = {
    "client_id": os.getenv("REDDIT_CLIENT_ID"),
    "client_secret": os.getenv("REDDIT_CLIENT_SECRET"),
    "user_agent": "u/chr0nomaton Build-Server-" + os.getenv("BACKEND_ID"),
}
reddit = Reddit(**reddit_conf)
 
@app.route('/comment')
def latest_cscq_comment():
    latest_post = reddit.subreddit('cscareerquestions').comments(limit=1)
    return [x.body for x in latest_post].pop()
 
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

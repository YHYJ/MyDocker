#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-05-22 17:51:17


"""

import os
import socket
import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)


def get_hit_count():
    """hit counter
    :returns: TODO

    """
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as error:
            if retries == 0:
                raise error
            retries -= 1
            time.sleep(0.5)


@app.route('/')
def hello():
    """TODO: Docstring for hello.
    :returns: TODO

    """
    count = get_hit_count()

    html = "<h3>Hello {name}! I have been seen {count} time.</h3>"\
            "<b>Hostname:</b> {hostname}<br/>"

    return html.format(name=os.getenv("NAME", "world"),
                       count=count,
                       hostname=socket.gethostname())


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)

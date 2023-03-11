import os
from flask import Flask, render_template

NODE = os.environ.get("NODE_INFOS")
POD_NAME = os.environ.get("POD_NAME")
APP_NAME = os.environ.get("APP_NAME")

app = Flask(__name__)

@app.route("/")
def main():
    return render_template("index.html", node=NODE, app=APP_NAME, pod=POD_NAME)

if __name__ == "__main__":
    from waitress import serve
    serve(app, host="0.0.0.0", port=5000)

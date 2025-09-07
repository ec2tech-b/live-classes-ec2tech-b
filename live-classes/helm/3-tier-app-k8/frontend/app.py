from flask import Flask, render_template, request, redirect
import requests
import os

app = Flask(__name__)

BACKEND_URL = os.getenv("BACKEND_URL", "http://backend:5000")

@app.route("/")
def index():
    users = requests.get(f"{BACKEND_URL}/users").json()
    return render_template("index.html", users=users)

@app.route("/add", methods=["POST"])
def add_user():
    name = request.form["name"]
    email = request.form["email"]
    requests.post(f"{BACKEND_URL}/users", json={"name": name, "email": email})
    return redirect("/")

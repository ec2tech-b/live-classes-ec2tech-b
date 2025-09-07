from flask import Flask, request, jsonify, render_template
import mysql.connector
import os

app = Flask(__name__, template_folder="templates")

# DB configs from env
DB_HOST = os.getenv("DB_HOST", "mysql")
DB_USER = os.getenv("DB_USER", "user1")
DB_PASSWORD = os.getenv("DB_PASSWORD", "user1pass")
DB_NAME = os.getenv("DB_NAME", "studentdb")

def get_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )

# Safer GET with error handling
@app.route("/users", methods=["GET"])
def get_users():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users")
        users = cursor.fetchall()
        conn.close()
        return jsonify(users)
    except Exception as e:
        print("DB error:", e)
        return jsonify([])   # never 500, always JSON

# POST (API)
@app.route("/users", methods=["POST"])
def add_user():
    try:
        data = request.json
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO users (name, email) VALUES (%s, %s)",
            (data["name"], data["email"])
        )
        conn.commit()
        conn.close()
        return jsonify({"message": "User added successfully"})
    except Exception as e:
        print("DB error:", e)
        return jsonify({"error": "Failed to add user"}), 500

# Simple form UI
@app.route("/add-user", methods=["GET", "POST"])
def add_user_form():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        try:
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO users (name, email) VALUES (%s, %s)",
                (name, email)
            )
            conn.commit()
            conn.close()
            msg = f"User {name} added!"
        except Exception as e:
            msg = f"Error: {e}"
        return render_template("add_user.html", message=msg)
    return render_template("add_user.html", message=None)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
